namespace :r18n do

    # need explain shell? try http://explainshell.com/explain?cmd=find+.+-name+\*.erb+-print+|+sed+%27p%3Bs%2F.erb%24%2F.haml%2F%27+|+xargs+-n2+html2haml
    desc 'create a es.haml copy of erb files'
    task :generatehaml do |t, args|
        sh "find . -name \\*.erb -print | sed 'p;s/.erb$/.es.haml/' | xargs -n2"
    end
end
