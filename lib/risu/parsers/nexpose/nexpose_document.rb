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
	module Parsers
		module Nexpose
			# A Object to represent the Nexpose xml file in memory
			#
			# @author Jacob Hammack <jacob.hammack@hammackj.com>
			class NexposeDocument

				# Creates a instance of the NexposeDocument class
				#
				def initialize document
					@document = document
				end

				# Checks the validness of a Nexpose
				#
				# @return [Boolean] True if valid, False if invalid
				def valid?
					if File.exist?(@document)
						@parser = LibXML::XML::Parser.file @document
						doc = @parser.parse

						if doc.root.name == nil
							return false
						end

						if doc.root.name == "NeXposeSimpleXML"
							return true
						else
							return false
						end
					else
						return false
					end
				end

				# Invokes the SAX parser on the XML document
				#
				def parse
					@parser = LibXML::XML::SaxParser.file @document
					@parser.callbacks = SimpleNexpose.new
					@parser.parse
				end

				# Fixes the ip field if nil and replaces it with the name if its an ip
				#
				def fix_ips
					@hosts = Host.all

					@hosts.each do |host|
						if host.ip == nil
							begin
								ip = IPAddr.new host.name
								host.ip = ip.to_string
								host.save
							rescue ArgumentError => ae
								next
							end
						end
					end
				end
			end
		end
	end
end
