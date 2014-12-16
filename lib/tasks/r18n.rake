namespace :r18n do

    # need explain shell? try http://explainshell.com/explain?cmd=find+.+-name+\*.erb+-print+|+sed+%27p%3Bs%2F.erb%24%2F.haml%2F%27+|+xargs+-n2+html2haml
    desc 'create a es.haml copy of erb files (initial workflow)' # TODO: not make this a destructive action
    task :erb2haml do |t, args|
        sh "find . -name \\*.erb -print | sed 'p;s/.html.erb$/.es.html.haml/' | xargs -n2 html2haml"
    end


    desc 'use rails to generate translation controllers (initial workflow)' # TODO: not make this a destructive action
    task :language_control do |t, args|
        sh "rails generate controller SetLanguage english spanish polish"
    end

end
