desc "create a new draft post: depends on ENV['TITLE'] and ENV['AUTHOR']"
task :post do
  title = ENV['TITLE']
  author = ENV['AUTHOR']

  if title.nil? || author.nil?
    abort("Please set ENV[TITLE] and ENV[AUTHOR]")
  end

  slug = "#{Time.now.strftime("%F")}-#{title.downcase.gsub(/[^\w]+/, '-')}"

  file = File.join(
    '_posts',
    slug + '.md'
  )

  File.open(file, "w") do |f|
    f << <<-EOS.gsub(/^    /, '')
    ---
    layout: single
    title: #{title}
    published: false
    comments: true
    categories:
    tags:
    description:
    author: #{author}
    ---

    EOS

    puts "Draft post #{file} created."
  end
end
