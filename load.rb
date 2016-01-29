EXCEPTIONS = %w{init.rb}
(%w{*.rb}).each do |directory|
  Dir[directory].each do |file|
    require_relative file unless EXCEPTIONS.include?(file)
  end
end