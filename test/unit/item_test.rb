# Copyright (c) 2010-2013 Arxopia LLC.
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

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
	test "returns 13 risks for Item.risks.count" do
		assert Item.risks.count == 13, "GOT #{Item.risks.count}"
	end

	test "returns 9 risks for Item.critical_risks.count" do
		assert Item.critical_risks.all.count == 9, "GOT #{Item.critical_risks.count}"
	end

	test "returns 1 risks for Item.high_risks.count" do
		assert Item.high_risks.all.count == 1
	end

	test "returns 1 for Item.medium_risks.count" do
		assert Item.medium_risks.all.count == 1
	end

	test "returns 1 for Item.low_risks.count" do
		assert Item.low_risks.all.count == 1
	end

	test "returns 1 risks for Item.info_risks.count" do
		assert Item.info_risks.all.count == 1
	end

	test "returns 12 risks for Item.risks_by_service" do
		assert Item.risks_by_service(100000).all.count == 12, "GOT #{Item.risks_by_service(100000).all.count}"
	end

	test "returns 2 risks for Item.risks_by_host" do
		assert Item.risks_by_host(100000).all.count == 2, "GOT #{Item.risks_by_host(100000).all.count}"
	end

	test "returns 8 risks for Item.risks_by_plugin" do
		assert Item.risks_by_plugin(100000).all.count == 8, "GOT #{Item.risks_by_plugin(100000).all.count}"
	end

	test "returns 8 for Item.critical_risks_unique.count" do
		assert Item.critical_risks_unique.all.count == 8, "GOT #{Item.critical_risks_unique.all.count}"
	end

	test "returns 1 for Item.high_risks_unique.count" do
		assert Item.high_risks_unique.all.count == 1
	end

	test "returns 1 for Item.high_risks_unique_sorted.count" do
		assert Item.high_risks_unique_sorted.all.count == 1
	end

	test "returns 8 for Item.critical_risks_unique_sorted.count" do
		assert Item.critical_risks_unique_sorted.all.count == 8, "GOT #{Item.critical_risks_unique_sorted.all.count}"
	end

	test "returns 1 for Item.medium_risks_unique.count" do
		assert Item.medium_risks_unique.all.count == 1
	end

	test "returns 1 for Item.medium_risks_unique_sorted.count" do
		assert Item.medium_risks_unique_sorted.all.count == 1
	end

	test "returns 1 for Item.low_risks_unique.count" do
		assert Item.low_risks_unique.all.count == 1
	end

	test "returns 1 for Item.low_risks_unique_sorted.count" do
		assert Item.low_risks_unique_sorted.all.count == 1
	end

	test "returns 1 for Item.info_risks_unique_sorted.count" do
		assert Item.info_risks_unique_sorted.all.count == 1
	end

	test "returns 1 for Item.info_risks_unique.count" do
		assert Item.info_risks_unique.all.count == 1, "GOT #{Item.info_risks_unique.all.count}"
	end

	# @todo this test sucks, hash the object instead
	test "returns a graph Item.risks_by_severity_graph" do
		assert Item.risks_by_severity_graph.class == StringIO
	end

	# @todo this test sucks, hash the object instead
	test "returns a graph Item.risks_by_service_graph" do
		assert Item.risks_by_service_graph.class == StringIO
	end

	test "returns 0 for Item.ms_update" do
		assert Item.ms_update.all.count == 0
	end

	test "returns 0 for Item.ms_patches" do
		assert Item.ms_patches.all.count == 0
	end

	test "returns 220 for Item.risks_by_service_graph_text.length" do
		assert Item.risks_by_service_graph_text.length == 220, "GOT #{Item.risks_by_service_graph_text.length}"
	end

	test "returns 1088 for Item.risks_by_severity_graph_text.length" do
		assert Item.risks_by_severity_graph_text.length == 1088, "GOT #{Item.risks_by_severity_graph_text.length}"
	end

	test "returns 12 for Item.all_risks_unique_sorted.all.count" do
		assert Item.all_risks_unique_sorted.all.count == 12, "GOT #{Item.all_risks_unique_sorted.all.count}"
	end

	test "return 100% for Item.calculate_vulnerable_host_percent" do
		assert Item.calculate_vulnerable_host_percent == 100, "GOT #{Item.calculate_vulnerable_host_percent}"
	end

	test "return excellent for Item.ajective_for_risk_text(1)" do
		assert Item.ajective_for_risk_text(1) == "excellent", "GOT #{Item.ajective_for_risk_text(1)}"
	end

	test "return good for Item.ajective_for_risk_text(6)" do
		assert Item.ajective_for_risk_text(6) == "great", "GOT #{Item.ajective_for_risk_text(6)}"
	end

	test "return excellent for Item.ajective_for_risk_text(12)" do
		assert Item.ajective_for_risk_text(12) == "good", "GOT #{Item.ajective_for_risk_text(12)}"
	end

	test "return excellent for Item.ajective_for_risk_text(17)" do
		assert Item.ajective_for_risk_text(17) == "fair", "GOT #{Item.ajective_for_risk_text(17)}"
	end

	test "return excellent for Item.ajective_for_risk_text(30)" do
		assert Item.ajective_for_risk_text(30) == "poor", "GOT #{Item.ajective_for_risk_text(30)}"
	end

	test "return 116 for Item.risk_text(1).length" do
		assert Item.risk_text(1).length == 116, "GOT #{Item.risk_text(1).length}"
	end

	test "return 205 for Item.risk_text(6).length" do
		assert Item.risk_text(6).length == 205, "GOT #{Item.risk_text(6).length}"
	end

	test "return 211 for Item.risk_text(12).length" do
		assert Item.risk_text(12).length == 211, "GOT #{Item.risk_text(12).length}"
	end

	test "return 211 for Item.risk_text(17).length" do
		assert Item.risk_text(17).length == 211, "GOT #{Item.risk_text(17).length}"
	end

	test "return 263 for Item.risk_text(30).length" do
		assert Item.risk_text(30).length == 263, "GOT #{Item.risk_text(30).length}"
	end

	test "return 2 for Item.critical_risks_by_host.all.count" do
		assert Item.critical_risks_by_host.all.count == 2, "GOT #{Item.critical_risks_by_host.all.count}"
	end

	test "return 1 for Item.high_risks_by_host.all.count" do
		assert Item.high_risks_by_host.all.count == 1, "GOT #{Item.high_risks_by_host.all.count}"
	end

	test "return 1 for Item.medium_risks_by_host.all.count" do
		assert Item.medium_risks_by_host.all.count == 1, "GOT #{Item.medium_risks_by_host.all.count}"
	end

	test "return 1 for Item.low_risks_by_host.all.count" do
		assert Item.low_risks_by_host.all.count == 1, "GOT #{Item.low_risks_by_host.all.count}"
	end

	test "notable_order_by_cvss_raw.count" do
		assert Item.notable_order_by_cvss_raw.count == 8, "GOT #{Item.notable_order_by_cvss_raw.count}"
	end

	test "return 21564 for Item.notable_order_by_cvss_raw.keys.first" do
		assert Item.notable_order_by_cvss_raw.keys.first == 21564, "GOT #{Item.notable_order_by_cvss_raw.keys.first}"
	end

	test "return 99999 for Item.notable_order_by_cvss_raw.keys.last" do
		assert Item.notable_order_by_cvss_raw.keys.last == 99999, "GOT #{Item.notable_order_by_cvss_raw.keys.last}"
	end

	test "return 99999 for Item.first.plugin.id" do
		assert Item.first.plugin.id == 99999, "GOT #{Item.first.plugin.id}"
	end
end
