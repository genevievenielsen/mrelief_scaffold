namespace :r18n do

    desc 'create a haml copy of view files'
    task :generatehaml do |t, args|
        sh "find . -name \\*.erb -print | sed 'p;s/.erb$"

    end
end
