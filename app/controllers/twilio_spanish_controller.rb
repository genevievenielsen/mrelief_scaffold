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
    if params[:Body].strip.downcase == "hello" || params[:Body].strip.downcase == "hi" || params[:Body].strip.downcase == "hola"
      session["counter"] = 0
    end

    if session["counter"] == 0
      message = "Bienvenido a mRelief! Le ayudamos comprobar su elegibilidad para sevicios como estampillas de comida, texto la palabra 'comida'. Si comete un error, enviar el mensaje 'reset' o 'inicio'."
    end

    # if params[:Body].strip.downcase == "menu"
    #    message = "For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.' If you make a mistake, send the message 'reset'."
    # end
    if params[:Body].strip.downcase == "food" || params[:Body].strip.downcase == "comida"
      message = "¿Está inscrito en una universidad o institución de educación superior? Ingrese 'si' o 'no'"
      session["page"] = "snap_college_question"
      session["counter"] = 1
    end
    # if params[:Body].strip.downcase == "ride"
    #    message = "Are you 65 years old or older? Enter 'yes' or 'no'"
    #    session["page"] = "rta_age_question"
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase == "medicaid"
    #    message = "Are you a citizen of the United States? Enter 'yes' or 'no'"
    #    session["page"] = "medicaid_citizen_question"
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase == "medicare"
    #    message = "What is your household size? Please include yourself, your spouse, your children under 18 who live with you."
    #    session["page"] = "medicare_household_question"
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase == "med"
    #    message = "For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'"
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase == "med"
    #    message = "For foodstamps, text the word 'food.'"
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("medicaid") || params[:Body].strip.downcase.include?("ride") || params[:Body].strip.downcase.include?("medicare")
    #    message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("medicaid") && params[:Body].strip.downcase.include?("ride")
    #    message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
    #    session["counter"] = 1
    # end
    # if params[:Body].strip.downcase.include?("food") && params[:Body].strip.downcase.include?("medicaid") && params[:Body].strip.downcase.include?("ride") && params[:Body].strip.downcase.include?("medicare")
    #    message = "You can only check your eligibility for one form at a time. For foodstamps, text the word 'food'. For RTA ride free, text the word 'ride.' For Medicaid, text the word 'medicaid.' For Medicare Cost Sharing, text the word 'medicare.'  "
    #    session["counter"] = 1
    # end

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
        message = "Puede que tenga suerte! Es probable que califica para cupones de alimentos. Para acceder sus estampillas de comida, vaya a #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}."
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
        message = "Puede que tenga suerte! Es probable que califica para cupones de alimentos. Para acceder sus estampillas de comida, vaya a #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i }, #{@lafcenter.telephone}."
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
      message = "no podemos determinar su elegibilidad en este momento. Para hablar con un experto sobre su situación con LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}."
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
      message = "no podemos determinar su elegibilidad en este momento. Para hablar con un experto sobre su situación con LAF #{@lafcenter.center} at #{@lafcenter.address} #{@lafcenter.city}, #{@lafcenter.zipcode.to_i } or call #{@lafcenter.telephone}."
    end

    twiml = Twilio::TwiML::Response.new do |r|
      r.Message message
    end
    session["counter"] += 1

    respond_to do |format|
      format.xml {render xml: twiml.text}
    end
  end

end
