# Загрузка данных из yml-файла с известной структурой
# использование bundle exec rake upload_data_from_yml:upload['db/menu.yml',true]
# первый параметр путь к yml файлу
# второй параметр нужно ли показывать лог (true / любое другое значение будет трактоваться как false)
# между параметрами не должно быть пробела после запятой

namespace :upload_data_from_yml do
  desc 'Uploading data from yml file with know structure'
  task :upload, %i[path show_log] => [:environment] do |_, args|
    Rails.logger = Logger.new($stdout) if args[:show_log] == 'true'
    path = args[:path]

    if path.nil?
      puts 'patch to file must be set' if args[:show_log] == 'true'
      break
    end

    file_path = Rails.root + path
    unless File.file?(file_path)
      puts "file not found at #{path}" if args[:show_log] == 'true'
      break
    end

    tables = YAML.load_file(file_path)

    # данный обработчик заточен строго под структуру указанного YML файла
    # При изменении структуры необходимо изменить и обработчик
    tables.each do |table|
      puts "uploading table #{table[0]}" if args[:show_log] == 'true'
      case table[0]
      when 'ingredients'
        Ingredient.create(table[1].map { |v| { name: v } })
      when 'dishes'
        Dish.create(table[1].map do |v|
          { name: v['name'], ingredients: Ingredient.where(name: v['ingredients']) }
        end)
      end
    end

  end
end
