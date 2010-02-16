require 'tempfile'

Before do
  @temp_dir = Pathname.new('tmp')
  @temp_dir.mkpath
end

After do
  @temp_dir.rmtree
end

Given /^there's a file "([^\"]*)" containing$/ do |file, string|
  path = @temp_dir + file
  path.open("w") do |f|
    f.write string
  end
end

When /^I run gsub with "([^\"]*)"$/ do |command|
  Dir.chdir @temp_dir do
    @output = %x(../gsub #{command} 2>&1)
  end
end

Then /^the output should be empty$/ do
  assert_equal "", @output
end

Then /^the file "([^\"]*)" should contain$/ do |file, string|
  path = @temp_dir + file
  tempfile = Tempfile.new("expected_")
  tempfile.write string
  tempfile.close
  diff = %x(diff -u #{tempfile.path.inspect} #{path.to_s.inspect})
  tempfile.unlink
  status = $?
  assert_equal 0, status.exitstatus, diff
end
