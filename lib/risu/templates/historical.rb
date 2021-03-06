# Copyright (c) 2010-2012 Arxopia LLC.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Arxopia LLC nor the names of its contributors
#     	may be used to endorse or promote products derived from this software
#     	without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ARXOPIA LLC BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
#OF THE POSSIBILITY OF SUCH DAMAGE.

module Risu
	module Templates
		class Historical < Risu::Base::TemplateBase


			def initialize ()
				@template_info =
				{
					:name => "historical",
					:author => "hammackj",
					:version => "0.0.1",
					:description => "Generates executive report with historial vulnerability data"
				}
			end


			def render(output)
				output.font_size 10

				output.text Report.classification.upcase, :align => :center
				output.text "\n"

				output.font_size(22) do
					output.text Report.title, :align => :center
				end

				output.font_size(12) do
					output.text "Executive Summary with historical data", :align => :center
					output.text "This report was prepared by #{Report.author}\n\n", :align => :center
				end

			all_admin = SystemAdmin.find_by_sql("SELECT * FROM system_admins")

			recent_fixed = Item.recent_vuln_fixed.count
			
			ratio = recent_fixed.to_f / all_admin.count.to_f

			output.text "In the past 90 days, each of the #{all_admin.count} admin have remediated an average of #{ratio} vulnerabilities.\n\n"

				
			
			curdate = Date.today

			output.text "As of #{curdate}, the following shows vulnerability information from the past 90 days:\n"

			output.text "Total vulnerabilities: #{Item.recent_vuln.count}"

			output.text "Fixed vulnerabilities: #{Item.recent_vuln_fixed.count}"

			output.text "Newly discovered vulnerabilities: #{Item.recent_vuln_new.count}"

			output.text "Existing vulnerabilites (prior to last scan): #{Item.recent_vuln_old.count}"

			output.image Item.recent_vuln_graph, :width => 300, :position => :center

			output.text "The following shows vulnerability information from all Nessus scans:"

			output.text "Number of new vulnerabilities: #{Item.new_items.count}"

			output.text "Number of old vulnerabilities: #{Item.old_items.count}"

			output.text "Number of fixed vulnerabilities: #{Item.fixed_items.count}"

			output.text "Number of ignored vulnerabilities: #{Item.ignored_items.count}"

			output.start_new_page

			output.text "Graphs of key finding statistics", :style => :bold
			output.move_down 75

			cury = output.y
			output.image Item.risks_by_severity_graph, :width => 250, :at => [output.bounds.left, cury]
			output.image Host.top_vuln_graph(10), :width => 250, :at => [output.bounds.right - 250, cury]
			output.move_down 250
			
			cury = output.y
			output.image Item.risks_by_service_graph(10), :width => 250, :at => [output.bounds.left, cury]
			output.image Host.other_os_graph, :width => 250, :at => [output.bounds.right - 250, cury]
			output.move_down 250

			#Item.all_items.each do |item|
			#name = Plugin.find_by_id(item.plugin_id).plugin_name
			#count = Item.where(:plugin_id => item.plugin_id).count

			#output.text "#{item.plugin_id} - #{item.plugin_name}"
			#end
		
			


			end
		end
	end
end

