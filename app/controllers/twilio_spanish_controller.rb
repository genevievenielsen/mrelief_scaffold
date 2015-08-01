# -*- coding: utf-8 -*-
require 'twilio-ruby'
class TwilioSpanishController < ApplicationController

  require 'numbers_in_words'
  require 'numbers_in_words/duck_punch' #see why later

  def text

    session["counter"] ||= 0

    if params[:Body].include?('"')
      params[:Body] = params[:Body].tr('"', '')
    end
    if params[:Body].include?("'")
      params[:Body] = params[:Body].tr("'", "")
    end
    #check here to see if a signature is included
    if params[:Body].strip.match(" ")
      params[:Body] = params[:Body].split(/ /).first
    end

    if params[:Body].strip.downcase == "reset" ||  params[:Body].strip.downcase == "inicio"
      session["counter"] = 0
    end
    if params[:Body].strip.downcase == "hello" || params[:Body].strip.downcase == "hi" || params[:Body].strip.downcase == "hola" || params[:Body].strip.downcase == "ola"
      session["counter"] = 0
    end

    if session["counter"] == 0
      message = "¡Bienvenido a mRelief! Nosotros le ayudamos a averiguar si califica para asistencia pública. Para estampillas de comida (food stamps) envíe un texto con la palabra ‘comida’. Para programas de educación temprana y cuidado de niños, envíe un text con la palabra ‘ninos’. Si cometa un error, envíe texto con la palabra 'reset' o 'inicio'."
    end



  
    if params[:Body].strip.downcase == "food" || params[:Body].strip.downcase == "comida"
      message = "¿Está inscrito en una universidad o institución de educación superior? Ingrese 'si' o 'no'"
      session["page"] = "snap_college_question"
      session["counter"] = 1
    end

    if params[:Body].strip.downcase == "ninos" || params[:Body].strip.downcase == "kids" || params[:Body].strip.downcase == "niños"
       message = "Escriba las letras que aplican a su hijo antes del 1º de Septiembre de 2015. Yo cuido a un(os) menor(es) entre las edades de: a. 0 a 2  b. 3 a 5 c. 6 a 12. d. Ninguno de estos. Ejemplo: ‘a’ o ‘ab’"
       session["page"] = "age_of_children_es"
       session["counter"] = 1
    end

    # HERE IS THE FOOD STAMPS LOGIC
    if session["page"] == "snap_college_question" && session["counter"] == 2
      session["college"] = params[:Body].strip.downcase
      if session["college"] == "no"
        message = "Es usted cuidadano de los Estados Unidos? Ingrese 'si' o 'no'"
        session["page"] = "snap_citizen_question"
      elsif session["college"] == "yes" || session["college"] == "si" # check
        message = "¿Cuál es su código postal?"
        session["page"] = "snap_zipcode_question"
      end
    end

    if session["page"] == "snap_citizen_question" && session["counter"] == 3
      session["citizen"] = params[:Body].strip.downcase
      if session["citizen"]  == "no"
        message = "¿Cuál es su código postal?"
        session["page"] = "snap_eligible_maybe"
      elsif session["citizen"]  == "yes" || session["citizen"] == "si"
        message = "¿Cuántos años tiene? Ingrese un número"
        session["page"] = "snap_age_question"
      end
    end

    if session["page"] == "snap_age_question" && session["counter"] == 4
      session["age"] = params[:Body].strip
      if session["age"]  !~ /\D/
        session["age"] = session["age"].to_i
      else
        session["age"] = session["age"].in_numbers
      end
      if session["age"] >= 18
        message = "¿Cuál es el número de personas que viven en el hogar incluyéndote a ti mismo? Ingrese un numero"
        session["page"] = "snap_household_question"
      else
        # message = "What is your zipcode?" ## afterthought to merely comment out original english string vars
        message = "¿Cuál es su código postal?"
        session["page"] = "snap_ineligible"
      end
    end

    if session["page"] == "snap_household_question" && session["counter"] == 5
      session["dependents"] = params[:Body].strip
      if session["dependents"] !~ /\D/  # returns true if all numbers
        session["dependents"] = session["dependents"].to_i
      else
        session["dependents"] = session["dependents"].in_numbers
      end
      # message = "What is your zipcode?"
      message = "¿Cuál es su código postal?"
      session["page"] = "snap_zipcode_question"
    end

    if session["page"] == "snap_zipcode_question" && session["counter"] == 6
      session["zipcode"] = params[:Body].strip
      # message = "Are you disabled? Enter 'yes' or 'no'"
      message = "¿Está usted incapacitado? Ingrese 'si' o 'no'"
      session["page"] = "snap_disability_question"
    end

    if session["page"] == "snap_disability_question" && session["counter"] == 7
      session["disability"] = params[:Body].strip.downcase
      if session["disability"]  == "no"
        # message = "What is the gross monthly income of all people living in your household including yourself? Income includes social security, child support, and unemployment insurance before any deductions."
        message = "¿Cuál es el ingreso mensual bruto de todas las personas que viven en el hogar incluyéndote a ti mismo? Los ingresos incluyen la seguridad social, la manutención de los hijos, y el seguro de desempleo antes de cualquier deducción."
        session["page"] = "snap_income_question"
      elsif session["disability"]  == "yes"
        # message = "Are you receiving disability payments from from Social Security, the Railroad Retirement Board or Veterans Affairs? Enter 'yes' or 'no'"
        message = "¿Está usted recibiendo pagos por incapacidad de del Seguro Social (Social Security), el Railraod Retirement Board o Veterans Affairs? Ingrese 'sí' o 'no'"
        session["page"] = "snap_disability_payment"
      end
    end

    if session["page"] == "snap_disability_payment" && session["counter"] == 8
      session["disability_payment"] = params[:Body].strip
      # message = "What is the gross monthly income of all people living in your household including yourself? Income includes social security, child support, and unemployment insurance before any deductions."
      message = message = "¿Cuál es el ingreso mensual bruto de todas las personas que viven en el hogar incluyéndote a ti mismo? Los ingresos incluyen la seguridad social, la manutención de los hijos, y el seguro de desempleo antes de cualquier deducción."
      if session["disability_payment"] == "yes"
        @disability
      end
      session["page"] = "snap_income_question_disability"
    end

    if session["page"] == "snap_income_question" && session["counter"] == 8
      session["income"] = params[:Body].strip
      if session["income"] !~ /\D/
        session["income"] = session["income"].to_i
      else
        if session["income"].include?("dollars")
          session["income"].slice!"dollars"
        end
        if session["income"].include?("$")
          session["income"].slice!"$"
        end
        if session["income"].include?(",")
          session["income"].slice!","
        end
        session["income"] = session["income"].in_numbers
      end
      age = session["age"].to_i
      snap_dependent_no = session["dependents"].to_i
      snap_gross_income = session["income"].to_i
      if age <= 59
        snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => snap_dependent_no })
      else
        snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => snap_dependent_no })
      end
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      @food_resources = ServiceCenter.where(:description => "food pantry")
      @food_resources_zip = @food_resources.where(:zip => user_zipcode)
      if @food_resources_zip.present?
        @food_pantry = @food_resources_zip.first
      else
        @food_pantry = @food_resources.first
      end
      if snap_gross_income < snap_eligibility.snap_gross_income
        # message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}."
        message = "Puede que tenga suerte! Es probable que califica para cupones de alimentos. Para acceder sus beneficios SNAP, vaya a #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}."
      else
        # message = "Based on your household size and income, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}."
        message = "Basado en el tamaño de su hogar y sus ingresos, es probable que no califica para cupones de alimentos. Una despensa de alimentos cerca de usted es #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}."
      end
    end
    if session["page"] == "snap_income_question_disability" && session["counter"] == 9
      session["income"] = params[:Body].strip
      if session["income"] !~ /\D/
        session["income"] = session["income"].to_i
      else
        if session["income"].include?("dollars")
          session["income"].slice!"dollars"
        end
        if session["income"].include?("$")
          session["income"].slice!"$"
        end
        if session["income"].include?(",")
          session["income"].slice!","
        end
        session["income"] = session["income"].in_numbers
      end
      snap_dependent_no = session["dependents"].to_i
      snap_gross_income = session["income"].to_i
      if @disability.present?
        snap_eligibility = SnapEligibilitySenior.find_by({ :snap_dependent_no => snap_dependent_no })
      else
        snap_eligibility = SnapEligibility.find_by({ :snap_dependent_no => snap_dependent_no })
      end
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      @food_resources = ServiceCenter.where(:description => "food pantry")
      @food_resources_zip = @food_resources.where(:zip => user_zipcode)
      if @food_resources_zip.present?
        @food_pantry = @food_resources_zip.first
      else
        @food_pantry = @food_resources.first
      end
      if snap_gross_income < snap_eligibility.snap_gross_income
        # message = "You may be in luck! You likely qualify for foodstamps. To access your food stamps, go to #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}."
        message = "Puede que tenga suerte! Es probable que califica para cupones de alimentos. Para acceder sus beneficios SNAP, vaya a #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}."
      else
        # message = "Based on your household size and income, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}."
        message = "Basado en el tamaño de su hogar y sus ingresos, es probable que no califica para cupones de alimentos. Una despensa de alimentos cerca de usted es #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}."
      end
    end

    # Food stamps user is younger than 22
    if session["page"] == "snap_ineligible" && session["counter"] == 5
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      @food_resources = ServiceCenter.where(:description => "food pantry")
      @food_resources_zip = @food_resources.where(:zip => user_zipcode)
      if @food_resources_zip.present?
        @food_pantry = @food_resources_zip.first
      else
        @food_pantry = @food_resources.first
      end
      # message = "Based on your age, you likely do not qualify for food stamps. A food pantry near you is #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}."
      message = "Basado en el tamaño de su hogar y sus ingresos, es probable que no califica para cupones de alimentos. Una despensa de alimentos cerca de usted es #{@food_pantry.name} - #{@food_pantry.street} #{@food_pantry.city} #{@food_pantry.state}, #{@food_pantry.zip} #{@food_pantry.phone}."
    end

    # Food stamps user is in school
    if session["page"] == "snap_zipcode_question" && session["counter"] == 3
      session["zipcode"] = params[:Body].strip
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      # message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}."
      message = "No podemos determinar su elegibilidad en este momento. Para hablar con un experto sobre su situación con LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}."
    end

    # Food stamps user is not a US citizen
    if session["page"] == "snap_eligible_maybe" && session["counter"] == 4
      session["zipcode"] = params[:Body].strip
      user_zipcode = session["zipcode"]
      @zipcode = user_zipcode << ".0"
      @lafcenter = LafCenter.find_by(:zipcode => @zipcode)
      if @lafcenter.present?
      else
        @lafcenter = LafCenter.find_by(:id => 10)
      end
      # message = "We cannot determine your eligibility at this time. To discuss your situation with a Food Stamp expert, go to the LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}."
      message = "No podemos determinar su elegibilidad en este momento. Para hablar con un experto sobre su situación con LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}."
    end

    # HERE IS THE EARLY LEARNING SPANISH LOGIC
    # number of children question
     if session["page"] == "age_of_children_es" && session["counter"] == 2
       @user = EarlyLearningDataTwilio.new
       @user.phone_number = params[:From]
       @user.children_ages = params[:Body].strip.downcase
       @user.spanish = true
       # no children
       if @user.children_ages.include?("d")
         @user.no_children = true
         message = "Usted posiblemente no califica para programas de aprendizaje temprano de Chicago: ¡Listo Para Aprender! Llame al 312-823-1100 para información sobre otras oportunidades."
         @user.completed = true
         @user.save
       # children
       elsif @user.children_ages.include?("a") || @user.children_ages.include?("b") || @user.children_ages.include?("c") 
         # Data storage for children ages
         if @user.children_ages.include?("a")
           @user.three_and_under = true
         end
         if @user.children_ages.include?("b")
           @user.three_to_five = true
         end
         if @user.children_ages.include?("c")
           @user.six_to_twelve = true
         end

         if @user.three_and_under != true
           message = "¿Está usted o su pareja embarazada? Ingrese si o no" 
           session["page"] = "pregnant_es"
         else
           message = "¿En qué código postal vive? Ejemplo: 60615"
           session["page"] = "zipcode_es"
         end
         @user.completed = false
         @user.save
       else
          message = "¡Parece que oprimió la letra equivocada! Por favor oprima, ‘a’, ‘b’, ‘c’, ‘d’ o una combinación de éstas para describir a su hogar."
          session["counter"] = session["counter"] - 1
          @user.completed = false
          @user.save
       end
     end

     # Pregnancy question
     if session["page"] == "pregnant_es" && session["counter"] == 3
       @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
       pregnant = params[:Body].strip.downcase
       session["counter"] += 1 # +1 to optional questions
       # Data Storage
       if pregnant == "sí" || pregnant == "si"
         @user.pregnant == true
         message = "¿En qué código postal vive? Ejemplo: 60615"
         session["page"] = "zipcode_es"

       elsif pregnant == "no"
         @user.pregnant == false
         message = "¿En qué código postal vive? Ejemplo: 60615"
         session["page"] = "zipcode_es"

       else
         message = "¡Parece que oprimió la letra equivocada! Por favor seleccione si o no"
         session["counter"] = session["counter"] - 1
       end

       @user.completed = false
       @user.save
     end

    # Zipcode question
    if session["page"] == "zipcode_es" 
     if session["counter"] == 3 || session["counter"] == 5
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     @user.zipcode = params[:Body].strip

     if ChicagoEligibleZipcode.all.pluck(:zipcode).include?(@user.zipcode)
       message = "¿Es usted un padre/madre de crianza temporal, en una situación de vida temporal, o su familia recibe SSI? Ingrese si o no"
       session["page"] = "categorical_income_eligibility_es" 
       @user.completed = false
       @user.save
     else
       # INELIGIBLE
       message = "Usted probablemente no califica en este momento para programas de aprendizaje temprano de Chicago: ¡Listo Para Aprender! Llame al 312-823-1100 para obtener información sobre otras oportunidades."
       @user.completed = true
       @user.save
     end

     end
    end

    # Categorical Income Eligibility 
    if session["page"] == "categorical_income_eligibility_es" 
     if session["counter"] == 4 || session["counter"] == 6
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     foster_temporary_ssi = params[:Body].strip.downcase

       if foster_temporary_ssi == "sí" || foster_temporary_ssi == "si"
        @user.foster_temporary_ssi == true
        session["page"] = "household_size_es" 
        message = "¿Cuántas personas viven en su hogar, incluyendo usted? Ejemplo: 2"
     
       elsif foster_temporary_ssi == "no"
         @user.foster_temporary_ssi == false
         session["page"] = "household_size_es" 
         message = "¿Cuántas personas viven en su hogar, incluyendo usted? Ejemplo: 2"

       else
         message = "¡Parece que oprimió la letra equivocada! Por favor seleccione si o no"
         session["counter"] = session["counter"] - 1
       end
       @user.completed = false
     end
    end

    # Household size question
    if session["page"] == "household_size_es" 
     if session["counter"] == 5 || session["counter"] == 7
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     household_size = params[:Body].strip
       # Convert to an integer
       if household_size !~ /\D/  # returns true if all numbers
         household_size_cleaned = household_size.to_i
       else
         household_size_cleaned = household_size.in_numbers
       end
       @user.household_size = household_size_cleaned.to_i
       @user.save

       message = "¿Cuál es su ingreso mensual total antes de impuestos? Ejemplo: 1000" 
       session["page"] = "income_es"
       @user.completed = false
       @user.save
     end
    end

    # Income question
    if session["page"] == "income_es" 
     if session["counter"] == 6 || session["counter"] == 8
     @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
     income = params[:Body].strip
       # Convert to an integer
       if income !~ /\D/  # returns true if all numbers
         income_cleaned = income.to_i
       else
         income_cleaned = income.in_numbers
       end
       @user.gross_monthly_income = income_cleaned.to_f
       # Determine income eligible programs
       income_row = EarlyLearningIncomeCutoff.find_by(household_size: @user.household_size.to_i)

       @user_income_type = []
       if @user.gross_monthly_income > income_row.income_type2 # Notice about co-pay?
         @user_income_type = ['Greater than Type 2']
       elsif @user.gross_monthly_income <= income_row.income_type2 && @user.gross_monthly_income > income_row.income_type1
         @user_income_type = ['Less than Type 2']
       elsif @user.gross_monthly_income <= income_row.income_type1
         @user_income_type = ['Less than Type 1', 'Less than Type 2']
       end
       @user.income_type = @user_income_type.try(:to_s)

       message = "¿Están todos los adultos  en su hogar actualmente empleados? Ingrese si o no"
       session["page"] = "employment_es"
       @user.early_learning_eligible = true
       @user.completed = false
       @user.save
     end
    end

    # Employment question
    if session["page"] == "employment_es" 
     if session["counter"] == 7 || session["counter"] == 9
      @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
      employment = params[:Body].strip.downcase
      
      if employment == "sí" || employment == "si"
        @user.employment == true
        # RESPONSE MESSAGE
        # CCAP eligible if below income cutoff 
         income_row = EarlyLearningIncomeCutoff.find_by({ :household_size => @user.household_size})
         if @user.gross_monthly_income < income_row.income_type4
           @user.ccap_eligible = true
           # child is ineligibe for early learning but eligible for ccap
           if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
           message = "¡Usted posiblemente califica para el Programa de Asistencia de Cuidado Infantil! Basado en la edad de su hijo/a y otros factores, no califica para programas de aprendizaje temprano, pero por favor llame al Equipo de Referencia de la Comunidad de Acción para los Niños de Illinois al (312) 229-1690 o visite bit.ly/learnearly para información."
           # child is eligible for early learning and ccap
           else
           message = "Usted posiblemente califica para programas de aprendizaje temprano de Chicago. También puede ser elegible para el Programa de Asistencia de Cuidado Infantil. Para inscribirse llame al (312) 229-1690 o visite bit.ly/learnearly para información."
           end
            @user.completed = true
         else
           session["page"] = "tanf_special_needs_es"
           message = "¿Recibe su familia TANF o cuidan a un menor con necesidades especiales o un plan de educación individualizado? Ingrese si o no"
           @user.completed = false
         end
         
      elsif employment == "no"
        @user.employment == false
        session["page"] = "tanf_special_needs_es"
        message = "¿Recibe su familia TANF o cuidan a un menor con necesidades especiales o un plan de educación individualizado? Ingrese si o no"
        @user.completed = false

      else
        message = "¡Parece que oprimió la letra equivocada! Por favor seleccione si o no"
        session["counter"] = session["counter"] - 1
        @user.completed = false
      end
     
      @user.save
     end
    end

    # Tanf and special needs question
    if session["page"] == "tanf_special_needs_es"
     if session["counter"] == 8 || session["counter"] == 10
      @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
      tanf_special_needs = params[:Body].strip.downcase
      
      # Data Storage
      if tanf_special_needs == "sí" || tanf_special_needs == "si"
        @user.tanf_special_needs == true
        # Eligible for CCAP
        # Child is ineligibe for early learning but eligible for CCAP
        if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
         message = "¡Usted posiblemente califica para el Programa de Asistencia de Cuidado Infantil! Basado en la edad de su hijo/a y otros factores, no califica para programas de aprendizaje temprano, pero por favor llame al Equipo de Referencia de la Comunidad de Acción para los Niños de Illinois al (312) 229-1100 o visite bit.ly/learnearly para información."
        # child is eligible for early learning and ccap
        else
         message = "Usted posiblemente califica para programas de aprendizaje temprano de Chicago. También puede ser elegible para el Programa de Asistencia de Cuidado Infantil. Para inscribirse llame al (312) 229-1690 o visite bit.ly/learnearly para información."
        end
         @user.completed = true

      elsif tanf_special_needs == "no"
        @user.tanf_special_needs == false
        session["page"] = "teen_parent_es"
        message = "¿Es usted un padre/madre adolescente inscrito(a) tiempo completo en escuela o clases de GED o su equivalente? Ingrese si o no"
        @user.completed = false
      else
        message = "¡Parece que oprimió la letra equivocada! Por favor seleccione si o no"
        session["counter"] = session["counter"] - 1
        @user.completed = false
      end

      @user.save
     end
    end

    # Teen parent question
    if session["page"] == "teen_parent_es"
     if session["counter"] == 9 || session["counter"] == 11
      @user = EarlyLearningDataTwilio.find_by(:phone_number => params[:From], :completed => false)
      teen_parent = params[:Body].strip.downcase
      
      # Data Storage
      if teen_parent == "sí" || teen_parent == "si"
        # RESPONSE MESSAGE
        # eligible for CCAP
        if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
        message = "¡Usted posiblemente califica para el Programa de Asistencia de Cuidado Infantil! Basado en la edad de su hijo/a y otros factores, no califica para programas de aprendizaje temprano, pero por favor llame al Equipo de Referencia de la Comunidad de Acción para los Niños de Illinois al (312) 229-1100 o visite bit.ly/learnearly para información."

        # child is eligible for early learning and ccap
        else
        message = "Usted posiblemente califica para programas de aprendizaje temprano de Chicago. También puede ser elegible para el Programa de Asistencia de Cuidado Infantil. Para inscribirse llame al (312) 229-1690 o visite bit.ly/learnearly para información."
        end
        @user.teen_parent == true
        @user.ccap_eligible = true
        @user.completed = true
      elsif teen_parent == "no"
        @user.teen_parent == false
         
         if @user.six_to_twelve == true && @user.three_and_under == false && @user.three_to_five == false && @user.pregnant == false
           message = "Usted posiblemente no califica para programas de aprendizaje temprano de Chicago: ¡Listo Para Aprender! Llame al 312-823-1100 para información sobre otras oportunidades."
         # eligible for early learning 
         else  
           # eligble for early learning with co-pay
           if @user.income_type == "[\"Greater than Type 2\"]"
            message = "Usted posiblemente no califica para programas de aprendizaje temprano de Chicago. Llame al (312) 229-1690 o visite bit.ly/learnearly para información. Tenga en cuenta: Basado en sus ingresos, usted puede tener algunos cargos adicionales."
           # eligible for early learning with no co-pay
           else
             message = "Usted probablemente califica para programas de de Chicago de aprendizaje temprano. Llame al (312) 229-1690 o visite bit.ly/learnearly para obtener información." 
           end
         @user.completed = true
         end
      else
        message = "¡Parece que oprimió la letra equivocada! Por favor seleccione si o no"
        session["counter"] = session["counter"] - 1
        @user.completed = false
      end
      @user.save
     end
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message message
    end
    session["counter"] += 1

    respond_to do |format|
      format.xml {render xml: twiml.text}
    end
  end

  include Webhookable

   after_filter :set_header

   skip_before_action :verify_authenticity_token

end
