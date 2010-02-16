Feature: Replace text in files
  In order to replace text easily in multiple files
  Console users should have a command line tool to do it
  
  Scenario: Replace text in a file
    Given there's a file "foo.txt" containing
      """
      Hello
      foo bar baz
      """
    When I run "./gsub '/bar/' 'BAR' foo.txt"
    Then the file "foo.txt" should contain
      """
      Hello
      foo BAR baz
      """
