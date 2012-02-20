module Risu
	module Templates
		class StigFindingsSummary < Risu::Base::TemplateBase
			
			# Initializes the template loading metadata
			#
			def initialize ()
				@template_info = 
				{ 
					:name => "stig_findings_summary", 
					:author => "hammackj", 
					:version => "0.0.1", 
					:description => "DISA Stig findings summary report"
				}
				
				@output = nil
			end

			#
			#
			def header
				@output.text Report.classification.upcase, :align => :center
				@output.text "\n"

				@output.font_size(22) do 
					@output.text Report.title, :align => :center
				end
				
				@output.font_size(18) do
					@output.text "Stig Findings Summary", :align => :center
					@output.text "\n"
					@output.text "This report was prepared by\n#{Report.author}", :align => :center
				end

				@output.text "\n\n\n"
			end
			
			# Creates a list of hosts from an list of Items 
			#
			# @param items
			def host_list_from_plugin_id(plugin_id)
 				Host.where('id IN (:hosts)', :hosts => Item.where(:plugin_id => plugin_id).select(:host_id).select('host_id AS id'))
			end
			
			def host_list_text(hosts)
				host_string = ""
				hosts.all.each do |host|
					host_string << "#{host.ip}"
					host_string << " (#{host.netbios})" if host.netbios
					host_string << ", "
				end

				return host_string.chomp!(", ")
			end
			
			# Generates stig finding text for 
			#
			# @param categeory I/II/III for each stig severity
			def stig_findings_text(categeory="I")
				if categeory != "I" || categeory != "II" || categeory != "III"
					return
				end
				
				stigs = Item.stig_findings(categeory).group(:plugin_id)
				
				stigs.each do |stig|	
					@output.text "#{stig.plugin_name}", :size => 16
					hosts = host_list_from_plugin_id(stig.plugin_id)
					hosts_string = host_list_text(hosts)
					
					if hosts.count > 1
						@output.text "<b>Hosts</b>: #{hosts_string}", :inline_format => true
					else
						@output.text "<b>Host</b>: #{hosts_string}", :inline_format => true
					end
					
					@output.text "<b>Risk</b>: #{stig.plugin.risk_factor}", :inline_format => true
					@output.text "<b>CVE Reference</b>: #{ref_string(stig.plugin.references.cve)}", :inline_format => true
					@output.text "<b>IAVA Reference</b>: #{ref_string(stig.plugin.references.iava)}", :inline_format => true
					
					if stig.plugin.description != nil
						@output.text "\nDescription:", :style => :bold
						@output.text stig.plugin.description
					end
					
					@output.text "\n"
				end
			end
			
			#
			#
			def ref_string ref
				return "" if ref == nil
								
				ref_string = ""
				ref.each do |r|
					ref_string << r.value + ", "
				end
				
				ref_string.chomp!(", ")
			end
			
			# Called during the rendering process
			#
			def render(output)
				@output = output

				@output.font_size 10

				header
				
				if Item.stig_findings("I").count > 0
					@output.text "<color rgb='551A8B'>Category I Findings</color>", :size => 18, :style => :bold, :inline_format => true
					stig_findings_text("I")
				end 
				
				if Item.stig_findings("II").count > 0
					@output.start_new_page
					@output.text "<color rgb='FF0000'>Category II Findings</color>", :size => 18, :style => :bold, :inline_format => true
					stig_findings_text("II")
				end 
				
				if Item.stig_findings("III").count > 0
					@output.start_new_page
					@output.text "<color rgb='FF8040'>Category III Findings</color>", :size => 18, :style => :bold, :inline_format => true
					stig_findings_text("III")
				end
				
				@output.number_pages "<page> of <total>", :at => [@output.bounds.right - 75, 0], :width => 150, :page_filter => :all
				
			end
		end
	end
end

