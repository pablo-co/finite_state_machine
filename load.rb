(%w{*.rb}).each do |directory|
  Dir[directory].each do |file|
    require_relative file
  end
end