module Ana
  module Scalars
    TTL = 900 # ~/gemjsons/gemname/*.json expires time.
    GEM_NOT_FOUND      = 'This rubygem could not be found.'
    GEM_DOES_NOT_EXIST = 'This gem does not exist.'
    GEM_VER_NOT_FOUND  = 'This version could not be found.'

    # Terminal Colour Codes
    # http://en.wikipedia.org/wiki/ANSI_escape_code
    BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = [*30..37]

    # $ curl https://rubygems.org/api/v1/gems/rails.json
    # URIs of above json
    URI_TYPE = {
      'proj' =>  'project_uri',
      'lib'  =>  'gem_uri',
      'home' =>  'homepage_uri',
      'wiki' =>  'wiki_uri',
      'doc'  =>  'documentation_uri',
      'mail' =>  'mailing_list_uri',
      'src'  =>  'source_code_uri',
      'bug'  =>  'bug_tracker_uri',
    }
  end
end