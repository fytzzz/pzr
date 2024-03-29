# Rm - project management software
# Copyright (C) 2006-2008  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module Rm
  module Activity
    #>> Rm::Activity.available_event_types
    #=> ["issues", "changesets", "news", "documents", "files", "wiki_edits", "messages", "time_entries"]
    #>> Rm::Activity.default_event_types
    #=> ["issues", "changesets", "news", "documents", "files"]
    #>> Rm::Activity.providers
    #=> {"messages"=>["Message"], "files"=>["Attachment"], "wiki_edits"=>["WikiContent::Version"], "changesets"=>["Changeset"], "documents"=>["Document", "Attachment"], "time_entries"=>["TimeEntry"], "news"=>["News"], "issues"=>["Issue", "Journal"]}

    mattr_accessor :available_event_types, :default_event_types, :providers
    
    @@available_event_types = []
    @@default_event_types = []
    @@providers = Hash.new {|h,k| h[k]=[] }

    class << self
      def map(&block)
        yield self
      end
      
      # Registers an activity provider
      def register(event_type, options={})
        options.assert_valid_keys(:class_name, :default)
        
        event_type = event_type.to_s
        providers = options[:class_name] || event_type.classify
        providers = ([] << providers) unless providers.is_a?(Array)
        
        @@available_event_types << event_type unless @@available_event_types.include?(event_type)
        @@default_event_types << event_type unless options[:default] == false
        @@providers[event_type] += providers
      end
    end
  end
end
