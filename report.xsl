<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

	<xsl:variable name="newline">
		<xsl:text>
</xsl:text>
	</xsl:variable>
	<xsl:param name="CreateDate"/>

	<xsl:variable name="hardline">
		<xsl:text>********************************************************************************************************************</xsl:text>
	</xsl:variable>


	<xsl:variable name="AcNameWidth">40</xsl:variable>

	<xsl:variable name="AcWidth">9</xsl:variable>

	<xsl:variable name="filedate">
		<xsl:for-each select="csv_data_records/record [Header=2] [Narration='AUD']">
			<xsl:value-of select="substring(BankCode,5,2)"/>
			<xsl:value-of select="substring(BankCode,3,2)"/>
			<xsl:value-of select="substring(BankCode,1,2)"/>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="vposArray">
		<xsl:value-of select="'|'"/>
		<xsl:for-each select="/*/record">
			<xsl:if test="Header=03">
				<xsl:value-of select="concat(position(), '|')"/>
			</xsl:if>
			<xsl:if test="position()=last()">
				<xsl:value-of select="concat(position(),'|')"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="MISWMallCNT">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr =400010434278 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="MISWMall" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='MIS']"/>
					<xsl:value-of select="count($MISWMall)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="FFNWMallCNT">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and (DrCr =400010434278 or DrCr=412910331870) and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="FFNWMall" select="following-sibling::record [position() &lt;=$vNumNested and DrCr=399 and BankCode='FFN']"/>
					<xsl:value-of select="count($FFNWMall)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="OURWMallCNT">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr =400010434278 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="OURWMall" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='AGN' and (agent=299 or agent=999)]"/>
					<xsl:value-of select="count($OURWMall)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<!-- Variable to count how many GSS MBF transactions there are -->
	<xsl:variable name="MISGSSmbfCNT">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr =400010453604 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="OURWMall" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='MIS' and contains(Narration,'MBF')]"/>
					<xsl:value-of select="count($OURWMall)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<!-- Variable to count how many GSS Medicare refunds there are -->
	<xsl:variable name="DEGSSmcareCNT">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr =400010453604 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="OURWMall" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='D E' and contains(Narration,'MCARE BENEFITS')]"/>
					<xsl:value-of select="count($OURWMall)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="MISWMallVAL">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr=400010434278  and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='MIS']"/>
					<xsl:value-of select="sum($QCC/./Amount)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<!-- A variable to value GSS MIS transactiosns -->
	<xsl:variable name="MISGSSmbfVAL">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr=400010453604  and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|')"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=$vNumNested and DrCr=399 and BankCode='MIS' and contains(Narration,'MBF')]"/>
					<xsl:value-of select="sum($QCC/./Amount)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="FFNWMallVAL">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and (DrCr=400010434278 or DrCr=412910331870) and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='FFN']"/>
					<xsl:value-of select="sum($QCC/./Amount)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<!-- A variable to handle GSS Medicare refunds -->
	<xsl:variable name="DEGSSmcareVAL">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr=400010453604 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='D E' and contains(Narration,'MCARE BENEFITS')]"/>
					<xsl:value-of select="sum($QCC/./Amount)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="OURWMallVAL">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr=400010434278 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='AGN' and (agent=299 or agent=999)]"/>
					<xsl:value-of select="sum($QCC/./Amount)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="WARbsbCNT" select="count(csv_data_records/record [BankCode='MIS'] [contains(Narration,'Daily 804603') or contains(Narration,'DAILY 804603')])"/>
	<xsl:variable name="WARfxupmtCNT" select="count(csv_data_records/record [BankCode='M T'] [contains(Narration,'FXUP') or contains(Narration,'WCHS INT TFR') or contains(Narration,'fxup')])"/> 	
	<xsl:variable name="WARfxupCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='M T' or BankCode='MIS'] [contains(Narration,'FXUP') or contains(Narration, 'WCHS INT TFR') or contains(Narration,'fxup')])"/>
	<xsl:variable name="AGNallCNT" select="count(csv_data_records/record [BankCode='AGN'])"/>
	<xsl:variable name="MISallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS'])"/>
	<xsl:variable name="MISbpyCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS']   [contains(Narration,'BPAY PAYMENTS CODE')])"/>
	<xsl:variable name="MISfhgCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS']   [contains(Narration,'FIRST HOME OWNER')])"/>
	<xsl:variable name="MISatoCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS']   [contains(Narration,'ATO98023685296')])"/>
	<xsl:variable name="FFNallCNT" select="count(csv_data_records/record [DrCr=399]   [BankCode='FFN'])"/>
	<xsl:variable name="OURallCNT" select="count(csv_data_records/record [DrCr=399] [agent=299 or agent =999])"/>
	<xsl:variable name="INTallCNT" select="count(csv_data_records/record [DrCr=399] [agent=276])"/>
	<xsl:variable name="DEallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='D E'])"/>
	<xsl:variable name="INSallCNT" select="count(csv_data_records/record [DrCr=399]   [BankCode='INS'])"/>
	<xsl:variable name="BPYallCNT" select="count(csv_data_records/record [DrCr=399] [Header=30])"/>
	<xsl:variable name="REVallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='REV'])"/>
	<xsl:variable name="WARbsbVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'Daily 804603')]/./Amount)"/>
	<xsl:variable name="WARbsb2VAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'DAILY 804603')]/./Amount)"/>
	<xsl:variable name="WARfxupmtVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='M T'] [contains(Narration,'FXUP') or contains(Narration, 'WCHS INT TFR') or contains(Narration,'fxup')]/./Amount)"/>
	<xsl:variable name="WARfxupVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='M T' or BankCode='MIS'] [contains(Narration,'FXUP') or contains(Narration, 'WCHS INT TFR') or contains(Narration,'fxup')]/./Amount)"/>
	<xsl:variable name="AGNallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='AGN']/./Amount)"/>
	<xsl:variable name="MISallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS']/./Amount)"/>
	<xsl:variable name="MISbpyVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS']   [contains(Narration,'BPAY PAYMENTS CODE')]/./Amount)"/>
	<xsl:variable name="MISfhgVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS']   [contains(Narration,'FIRST HOME OWNER')]/./Amount)"/>
	<xsl:variable name="MISatoVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS']   [contains(Narration,'ATO98023685296')]/./Amount)"/>
	<xsl:variable name="FFNallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='FFN']/./Amount)"/>
	<xsl:variable name="OURallVAL" select="sum(csv_data_records/record [DrCr=399] [agent=299 or agent=999]/./Amount)"/>
	<xsl:variable name="INTallVAL" select="sum(csv_data_records/record [DrCr=399] [agent=276]/./Amount)"/>
	<xsl:variable name="DEallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='D E']/./Amount)"/>
	<xsl:variable name="REVallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='REV']/./Amount)"/>
	<xsl:variable name="INSallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='INS']/./Amount)"/>
	<xsl:variable name="BPYallVAL" select="sum(csv_data_records/record [DrCr=399] [Header=30]/./Amount)"/>
	<xsl:variable name="AllTrans">
		<xsl:value-of select="$AGNallCNT + $DEallCNT  + $FFNallCNT  + $INSallCNT + $MISallCNT - $MISWMallCNT   - $MISbpyCNT - $OURallCNT  -  $MISfhgCNT  - $INTallCNT - $MISatoCNT "/>
	</xsl:variable>


	<xsl:template match="csv_data_records">
		<xsl:call-template name="Header"/>
		<xsl:apply-templates select="record"/>
		<xsl:call-template name="Totals"/>
	</xsl:template>

	<xsl:template match="record">
		<xsl:choose>
			<!-- Header=03 and date=15 means this is the start of an bank acocunt, about to list all normal transactions -->
			<xsl:when test="Header=03 and not(DrCr=400010434278)  and  date=15">
				<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|')"/>
				<xsl:variable name="vNumNested" select="$vposNext - position() - 2"/>
				<xsl:variable name="QCHSitems" select="following-sibling::record [position()      &lt;= $vNumNested and DrCr=399 and Header=16]"/>
				<xsl:variable name="AcName">
					<xsl:choose>
						<xsl:when test="DrCr=400011340003">
							<xsl:value-of select="'War 37(5)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010237071">
							<xsl:value-of select="'War 35'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010369955">
							<xsl:value-of select="'War 34(1)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010435684">
							<xsl:value-of select="'War 34(2)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010499346">
							<xsl:value-of select="'War 37(1)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010510525">
							<xsl:value-of select="'War 37(2)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010958207">
							<xsl:value-of select="'War 37(3)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400011123906">
							<xsl:value-of select="'War 37(4)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010470850">
							<xsl:value-of select="'War 25'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010470869">
							<xsl:value-of select="'War 31'"/>
						</xsl:when>
						<xsl:when test="DrCr=412200242858">
							<xsl:value-of select="'Red 20'"/>
						</xsl:when>
						<xsl:when test="DrCr=400100912819">
							<xsl:value-of select="'MM43'"/>
						</xsl:when>
						<xsl:when test="DrCr=400100095687">
							<xsl:value-of select="'ANZ15'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010434278">
							<xsl:value-of select="'WarMan'"/>
						</xsl:when>
						<xsl:when test="DrCr=443300080331">
							<xsl:value-of select="'GC 36'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010453604">
							<xsl:value-of select="'GSS'"/>
						</xsl:when>
						<xsl:when test="DrCr=4255460097384">
							<xsl:value-of select="'W21'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'Other Account'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="processStatDataItems">
					<xsl:with-param name="items" select="$QCHSitems"/>
					<xsl:with-param name="account" select="$AcName"/>
				</xsl:call-template>
			</xsl:when>
			<!-- Header=03 and date=231 means this is the start of an bank account, about to list all BPAY transactions -->
			<xsl:when test="Header=03  and date=231">
				<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'      )"/>
				<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
				<xsl:variable name="QCHSitems" select="following-sibling::record [position()      &lt;= $vNumNested and DrCr=399 and Header=30]"/>
				<xsl:variable name="AcName">
					<xsl:choose>
						<xsl:when test="DrCr=400011340003">
							<xsl:value-of select="'War 37(5)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010237071">
							<xsl:value-of select="'War 35'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010369955">
							<xsl:value-of select="'War 34(1)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010435684">
							<xsl:value-of select="'War 34(2)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010499346">
							<xsl:value-of select="'War 37(1)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010510525">
							<xsl:value-of select="'War 37(2)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010958207">
							<xsl:value-of select="'War 37(3)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400011123906">
							<xsl:value-of select="'War 37(4)'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010470850">
							<xsl:value-of select="'War 25'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010470869">
							<xsl:value-of select="'War 31'"/>
						</xsl:when>
						<xsl:when test="DrCr=412200242858">
							<xsl:value-of select="'Red 20'"/>
						</xsl:when>
						<xsl:when test="DrCr=400100912819">
							<xsl:value-of select="'MM43'"/>
						</xsl:when>
						<xsl:when test="DrCr=400100095687">
							<xsl:value-of select="'ANZ15'"/>
						</xsl:when>
						<xsl:when test="DrCr=443300080331">
							<xsl:value-of select="'GC 36'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010434278">
							<xsl:value-of select="'WarMan'"/>
						</xsl:when>
						<xsl:when test="DrCr=4255460097384">
							<xsl:value-of select="'W21'"/>
						</xsl:when>
						<xsl:when test="DrCr=400010453604">
							<xsl:value-of select="'GSS'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'Other Account'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$newline"/>
				<xsl:call-template name="processBPAYItems">
					<xsl:with-param name="items" select="$QCHSitems"/>
					<xsl:with-param name="account" select="$AcName"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="processStatDataItems">
		<xsl:param name="items"/>
		<xsl:param name="account"/>

		<xsl:for-each select="$items">

			<xsl:sort select="BankCode"/>
			<xsl:sort select="agent" data-type="number"/>
			<xsl:sort select="Narration"/>

			<!-- 060809 Now do a lookup at this stage to see if there is a mapping from the Narration to an account number.
			Leave the result in a variable called MappedAccountNumber -->
			<xsl:call-template name="checkMaps">
				<xsl:with-param name="preMap" select="Narration"/>
				<xsl:with-param name="account" select="$account"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="processBPAYItems">
		<xsl:param name="items"/>
		<xsl:param name="account"/>

		<xsl:choose>
			<xsl:when test="$account='War 35'">
				<xsl:choose>
					<xsl:when test="$AllTrans &lt; 36">
						<xsl:call-template name="loop">
							<xsl:with-param name="repeat" select="34-$AllTrans"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$AllTrans &lt; 76">
						<xsl:call-template name="loop">
							<xsl:with-param name="repeat" select="74-$AllTrans"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$AllTrans &lt; 116">
						<xsl:call-template name="loop">
							<xsl:with-param name="repeat" select="114-$AllTrans"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>

		<xsl:call-template name="BpyHeader"/>
		<xsl:for-each select="$items [DrCr=399] [Header=30]">
			<xsl:call-template name="BPAYTrim"/>
			<xsl:text>_____BPAY DEPOSIT____________________________</xsl:text>
			<xsl:apply-templates select="Amount"/>
			<xsl:value-of select="concat('    ',$account)"/>
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="concat('  Total BPAY transactions for ',$account,' : ',format-number(sum($items [DrCr=399] [Header=30] /./Amount) div 100,'$###,###,###.00'))"/>
	</xsl:template>


	<xsl:template name="LeftPadAGN">
		<xsl:variable name="mappedAccountNumber">
			<xsl:variable name="agent" select="agent"/>
			<xsl:for-each select="document('mappings.xml')/mappings/map_agent/agent">

				<xsl:if test="$agent=.">
					<xsl:value-of select="../account"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>


		<xsl:variable name="AgentLookedUp">
			<xsl:choose>
				<xsl:when test="(string-length($mappedAccountNumber) &gt; 9)">
					<xsl:text>MULTIMAP</xsl:text>
				</xsl:when>
				<xsl:when test="(string-length($mappedAccountNumber) &gt; 0 and string-length($mappedAccountNumber) &lt; 10)">
					<xsl:value-of select="$mappedAccountNumber"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="agent"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ValueLength" select="string-length(normalize-space($AgentLookedUp))"/>
		<xsl:variable name="padding" select="$AcWidth - $ValueLength"/>
		<xsl:value-of select="substring('          ',1,$padding)"/>
		<xsl:value-of select="normalize-space($AgentLookedUp)"/>
	</xsl:template>

	<xsl:template name="Narr37">
		<xsl:variable name="NoNastys" select="normalize-space(translate(Narration,    '*&amp;.-',''))"/>
		<xsl:variable name="ValueLength" select="string-length(normalize-space($NoNastys))"/>
		<xsl:variable name="LengthWithNastys" select="string-length(normalize-space(Narration))"/>
<xsl:if test="$LengthWithNastys &gt; string-length($NoNastys)">
<xsl:variable name="padding" select="36-$ValueLength"/>
<xsl:value-of select="substring('                                           ',1,$padding)"/>
<xsl:text>*</xsl:text>
</xsl:if>
<xsl:if test="$LengthWithNastys = string-length($NoNastys)">
<xsl:variable name="padding" select="37-$ValueLength"/>
<xsl:value-of select="substring('                                           ',1,$padding)"/>
</xsl:if>	
		
		<xsl:value-of select="normalize-space($NoNastys)"/>
	</xsl:template>


	<xsl:template name="RemoveDigits">
		<xsl:variable name="AccountName">
			<xsl:variable name="valueUnstripped" select="string-length(normalize-space(Narration))"/>
			<xsl:variable name="valueStripped" select="string-length(normalize-space(translate(Narration, '*#1234567890&amp;.-','')))"/>
			<xsl:choose>
				<xsl:when test="BankCode='AGN'">
					<xsl:value-of select="substring(concat('DEPOSIT ',agent,'______________________________________'),1,$AcNameWidth)"/>
				</xsl:when>
				<xsl:when test="$valueUnstripped &lt; 17">
					<xsl:value-of select="substring(concat(normalize-space(Narration),'_______________________________________'),1,$AcNameWidth)"/>
				</xsl:when>
				<xsl:when test="$valueUnstripped &gt; 16">
					<xsl:value-of select="substring(concat(normalize-space(translate(Narration, '*#1234567890&amp;.-','')),'________________________________________'),1,$AcNameWidth)"/>
				</xsl:when>
				<xsl:otherwise>NO NAME PROVIDED________________________</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$AccountName"/>
	</xsl:template>
	<xsl:template name="LeftPad">
		<xsl:variable name="LettersOnly" select="translate(Narration, '1234567890&amp;.-','')"/>
		<xsl:variable name="valueLength" select="string-length(normalize-space($LettersOnly))"/>
		<xsl:variable name="padding" select="$AcNameWidth - $valueLength"/>
		<xsl:value-of select="substring('                          ',1,$padding)"/>
		<xsl:value-of select="Narration"/>
	</xsl:template>

	<xsl:template name="RemoveAlphas">
		<xsl:param name="mappedAccountNumber"/>
		<xsl:variable name="AccountNo">

			<xsl:choose>
				<!-- See if the earlier look up of mappings resulted in an account number - if so, use this value -->
				<xsl:when test="(string-length($mappedAccountNumber) &gt; 9)">
					<xsl:text>MULTIMAP</xsl:text>
				</xsl:when>
				<xsl:when test="(string-length($mappedAccountNumber) &gt; 0 and string-length($mappedAccountNumber) &lt; 10)">
					<xsl:value-of select="$mappedAccountNumber"/>
				</xsl:when>
				<!-- just return the number in the narration, stripped of alpha characters -->
				<xsl:when test="translate(Narration,'#*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ&amp;:. -','')">
					<!-- If no valid mapped reference then just strip out the non-numeric characters from the reference-->
					<xsl:variable name="NoLetters" select="translate(Narration,'#*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ&amp;:. -','')"/>
					<xsl:variable name="ValueLength" select="string-length(normalize-space($NoLetters))"/>
					<xsl:choose>
						<xsl:when test="$ValueLength &gt; $AcWidth">
							<xsl:value-of select="substring($NoLetters,1,$AcWidth)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="padding" select="$AcWidth - $ValueLength"/>
							<xsl:value-of select="substring('                  ',1,$padding)"/>
							<xsl:value-of select="$NoLetters"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>123456***</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ValueLength" select="string-length(normalize-space($AccountNo))"/>
		<xsl:variable name="padding" select="$AcWidth - $ValueLength"/>
		<xsl:value-of select="substring('                  ',1,$padding)"/>
		<xsl:value-of select="normalize-space($AccountNo)"/>
	</xsl:template>

	<xsl:template name="BPAYTrim">
		<xsl:variable name="BPAYNo">
			<xsl:variable name="ValueLength" select="string-length(BankCode)"/>
			<xsl:choose>
				<xsl:when test="$ValueLength &gt; 9">
					<xsl:value-of select="substring(BankCode,1,$AcWidth)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="padding" select="$AcWidth - $ValueLength"/>
					<xsl:value-of select="substring('         ',1,$padding + 1)"/>
					<xsl:value-of select="substring(BankCode,1,$ValueLength - 1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$BPAYNo"/>
	</xsl:template>

	<xsl:template match="Amount">
		<xsl:variable name="valueLength" select="string-length(format-number((. div    100),'$###,###,##0.00'))"/>
		<xsl:variable name="padding" select="11 - $valueLength"/>
		<xsl:value-of select="substring('            ',1,$padding)"/>
		<xsl:value-of select="format-number((. div 100),'$###,###,##0.00')"/>
	</xsl:template>
	<xsl:template name="Totals">

		<xsl:value-of select="$newline"/>
		<xsl:text>              Number of Transactions = </xsl:text>
		<xsl:value-of select="($AGNallCNT  + $DEallCNT  + $FFNallCNT - $FFNWMallCNT + $INSallCNT  + $MISallCNT  - $MISWMallCNT +    $BPYallCNT -    $MISbpyCNT   - $OURallCNT  -    $MISfhgCNT  - $INTallCNT  - $MISatoCNT  - $WARbsbCNT - $WARfxupCNT + $WARfxupmtCNT - $DEGSSmcareCNT - $MISGSSmbfCNT)"/>
		<xsl:text>             </xsl:text>
		<xsl:value-of select="format-number((($AGNallVAL  + $DEallVAL  + $FFNallVAL - $FFNWMallVAL  + $INSallVAL + $MISallVAL  - $MISWMallVAL + $BPYallVAL  -  $MISbpyVAL  - $OURallVAL  - $MISfhgVAL  - $INTallVAL  - $MISatoVAL  - $WARbsbVAL - $WARbsb2VAL + $WARfxupmtVAL - $WARfxupVAL - $DEGSSmcareVAL - $MISGSSmbfVAL) div 100),'$###,##0.00')"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="concat('AGN ',$AGNallCNT   - $OURallCNT ,' ',format-number(($AGNallVAL  - $OURallVAL ) div 100,'$###,##0.00'),'     MIS ',$MISallCNT   - $MISWMallCNT  - $MISbpyCNT  - $MISatoCNT  -  $WARbsbCNT -$WARfxupCNT - $MISfhgCNT - $MISGSSmbfCNT,'  ',format-number(($MISallVAL  - $MISWMallVAL   - $MISbpyVAL  - $MISatoVAL  - $MISfhgVAL - $WARbsb2VAL +$WARfxupmtVAL - $WARfxupVAL - $WARbsbVAL -$MISGSSmbfVAL) div 100,'$###,##0.00'),'     INS ',$INSallCNT,'  ',format-number(($INSallVAL) div 100,'$###,##0.00'),'     DE ',$DEallCNT - $DEGSSmcareCNT,'  ',format-number(($DEallVAL - $DEGSSmcareVAL) div 100,'$###,##0.00'),'     FFN ',$FFNallCNT,'  ',format-number(($FFNallVAL - $FFNWMallVAL) div 100,'$###,##0.00'),'     BPAY ',$BPYallCNT,'  ',format-number(($BPYallVAL) div 100,'$###,##0.00'))"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$hardline"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:text>FHOG, ATO refunds, Agent 276 (CBA Term Deposit tfers),  Agent 299/999 transactions, Daily 804603 and REV transactions (not exported)</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:for-each select="record">
			<xsl:choose>

				<xsl:when test="Header=03 and not (DrCr=412900169091 or DrCr=400010434278 or DrCr=412910022939) and date=15">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|')"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 2"/>
					<xsl:variable name="QCHSitems" select="following-sibling::record [position()       &lt;= $vNumNested and DrCr=399 and Header=16]"/>
					<xsl:variable name="AcName">
						<xsl:choose>
							<xsl:when test="DrCr=400011340003">
								<xsl:value-of select="'War 37(5)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010237071">
								<xsl:value-of select="'War 35'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010369955">
								<xsl:value-of select="'War 34(1)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010435684">
								<xsl:value-of select="'War 34(2)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010499346">
								<xsl:value-of select="'War 37(1)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010510525">
								<xsl:value-of select="'War 37(2)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010958207">
								<xsl:value-of select="'War 37(3)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400011123906">
								<xsl:value-of select="'War 37(4)'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010470850">
								<xsl:value-of select="'War 25'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010470869">
								<xsl:value-of select="'War 31'"/>
							</xsl:when>
							<xsl:when test="DrCr=412200242858">
								<xsl:value-of select="'Red 20'"/>
							</xsl:when>
							<xsl:when test="DrCr=400100912819">
								<xsl:value-of select="'MM43'"/>
							</xsl:when>
							<xsl:when test="DrCr=400100095687">
								<xsl:value-of select="'ANZ15'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010434278">
								<xsl:value-of select="'WarMan'"/>
							</xsl:when>
							<xsl:when test="DrCr=443300080331">
								<xsl:value-of select="'GC 36'"/>
							</xsl:when>
							<xsl:when test="DrCr=400010453604">
								<xsl:value-of select="'GSS'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'Other Account'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="QCHSnonexports">
						<xsl:with-param name="items" select="$QCHSitems"/>
						<xsl:with-param name="account" select="$AcName"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>

		<xsl:value-of select="$newline"/>
		<xsl:text>              Number of Transactions = </xsl:text>
		<xsl:value-of select="($OURallCNT + $MISfhgCNT+ $INTallCNT + $MISatoCNT  - $OURWMallCNT + $WARbsbCNT  + $WARfxupCNT + $REVallCNT)"/>
		<xsl:text>               </xsl:text>
		<xsl:value-of select="format-number(($OURallVAL + $MISfhgVAL + $INTallVAL + $MISatoVAL - $OURWMallVAL + $WARbsbVAL  + $WARfxupVAL + $WARbsb2VAL +$REVallVAL) div    100,'$###,###.00')"/>
	</xsl:template>

	<xsl:template name="QCHSnonexports">
		<xsl:param name="items"/>
		<xsl:param name="account"/>
		<xsl:for-each select="$items">
			<xsl:choose>
				<xsl:when test="BankCode='AGN' and (agent=299 or agent=999)">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="LeftPadAGN"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<xsl:when test="BankCode='MIS' and (contains(Narration,'FIRST HOME OWNER'))">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<xsl:when test="BankCode='MIS' and (contains(Narration,'ATO98023685296'))">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<xsl:when test="BankCode='D E' and agent=276">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<xsl:when test="BankCode='MIS' and ((contains(Narration,'Daily 804603')) or contains(Narration,'DAILY 804603') or contains(Narration,'fxup') or contains(Narration, 'WCHS INT TFR') or contains(Narration,'WCHS Int Loan Tfr') or contains(Narration,'FXUP'))">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<xsl:when test="BankCode='M T' and ((contains(Narration,'FXUP')) or contains(Narration, 'WCHS INT TFR') or contains(Narration,'WCHS Int Loan Tfr') or contains(Narration,'fxup'))">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>

				<xsl:when test="BankCode='MIS' and ((contains(Narration,'FXUP')) or contains(Narration,'WCHS Int Loan Tfr') or contains(Narration, 'WCHS INT TFR') or contains(Narration,'fxup'))">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<xsl:when test="BankCode='REV'">
					<xsl:value-of select="concat(BankCode,'                      ')"/>
					<xsl:call-template name="RemoveAlphas"/>
					<xsl:text>      </xsl:text>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:apply-templates select="Amount"/>
					<xsl:value-of select="concat('    ',$account)"/>
					<xsl:value-of select="$newline"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="Header">
		<xsl:text>These are the transactions imported for Waratah Co-op Housing Society - data for </xsl:text>
		<xsl:value-of select="$filedate"/>
		<xsl:value-of select="$newline"/>
		<xsl:text>This file was created </xsl:text>
		<xsl:value-of select="$CreateDate"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:text>   Member     Narration (this will be posted on account)   Amount         Original Narration  supplied    Society</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template name="BpyHeader">
		<xsl:text>These are the BPay transactions imported for Waratah Co-Op Housing Society - data for </xsl:text>
		<xsl:value-of select="$filedate"/>
		<xsl:value-of select="$newline"/>
		<xsl:text>This file was created </xsl:text>
		<xsl:value-of select="$CreateDate"/>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
		<xsl:text>   Member     Narration                                    Amount    Society</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template name="loop">
		<xsl:param name="repeat">0</xsl:param>
		<xsl:if test="number($repeat) &gt;= 1">
			<xsl:value-of select="$newline"/>
<xsl:if test="number($repeat) = (33 - $AllTrans)">
<xsl:text>Narrations starting with the * symbol indicate the narration has been edited from the version appearing on the bank statement</xsl:text>
			</xsl:if>
			<xsl:call-template name="loop">
				<xsl:with-param name="repeat" select="$repeat - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="checkMaps">
		<xsl:param name="preMap"/>
		<xsl:param name="account"/>
		<xsl:variable name="mappedAccountNumber">
			<xsl:for-each select="document('mappings.xml')/mappings/map/To ">
				<xsl:variable name="check">
					<xsl:for-each select="preceding-sibling::*">
						<xsl:if test="contains($preMap,.)">0</xsl:if>
						<xsl:if test="not(contains($preMap,.))">1</xsl:if>
					</xsl:for-each>
					<!-- 310809 VB rewrites the xml file in uncontrolled order, so it may be a preceding or a following sibling that we need to check -->
					<xsl:for-each select="following-sibling::*">
						<xsl:if test="contains($preMap,.)">0</xsl:if>
						<xsl:if test="not(contains($preMap,.))">1</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:if test="not(contains($check,'1'))">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="printRowDetails">
			<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
			<xsl:with-param name="account" select="$account"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="printRowDetails">
		<xsl:param name="mappedAccountNumber"/>
		<xsl:param name="account"/>
		<xsl:choose>
			<xsl:when test="BankCode='MIS' and DrCr=399 and not (contains(Narration,'Daily 804603')) and not(contains(Narration,'DAILY 804603')) and not(contains(Narration,'FIRST HOME OWNER')) and not(contains(Narration,'BPAY PAYMENTS CODE')) and not (contains(Narration,'FXUP')) and not (contains(Narration,'WCHS Int Loan Tfr')) and not (contains(Narration, 'WCHS INT TFR'))and not(contains(Narration,'fxup'))and  not(contains(Narration,'ATO98023685296')) and not($account='GSS' and contains(Narration,'MBF'))">
				<xsl:call-template name="RemoveAlphas">
					<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
				<xsl:text>_____</xsl:text>
				<xsl:call-template name="RemoveDigits"/>
				<xsl:apply-templates select="Amount"/>
				<xsl:call-template name="Narr37"/>
				<xsl:value-of select="concat('    ',$account)"/>
				<xsl:value-of select="$newline"/>
			</xsl:when>

			<xsl:when test="BankCode='INS' and DrCr=399 ">
				<xsl:call-template name="RemoveAlphas">
				<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
				<xsl:text>_____</xsl:text>
				<xsl:call-template name="RemoveDigits"/>
				<xsl:apply-templates select="Amount"/>
				<xsl:call-template name="Narr37"/>
				<xsl:value-of select="concat('    ',$account)"/>
				<xsl:value-of select="$newline"/>
			</xsl:when>

			<xsl:when test="BankCode='D E' and DrCr=399 and not(agent=276) and not(contains(Narration,'MCARE BENEFITS'))">
				<xsl:call-template name="RemoveAlphas">
				<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
				<xsl:text>_____</xsl:text>
				<xsl:call-template name="RemoveDigits"/>
				<xsl:apply-templates select="Amount"/>
				<xsl:call-template name="Narr37"/>
				<xsl:value-of select="concat('    ',$account)"/>
				<xsl:value-of select="$newline"/>
			</xsl:when>

			<xsl:when test="BankCode='FFN' and DrCr=399">
				<xsl:call-template name="RemoveAlphas">
				<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
				<xsl:text>_____</xsl:text>
				<xsl:call-template name="RemoveDigits"/>
				<xsl:apply-templates select="Amount"/>
				<xsl:call-template name="Narr37"/>
				<xsl:value-of select="concat('    ',$account)"/>
				<xsl:value-of select="$newline"/>
			</xsl:when>

			<xsl:when test="BankCode='AGN' and DrCr=399 and not(agent=299) and not(agent=999)">
				<xsl:call-template name="LeftPadAGN"/>
				<xsl:text>_____</xsl:text>
				<xsl:call-template name="RemoveDigits"/>
				<xsl:apply-templates select="Amount"/>
				<xsl:variable name="ValueLength" select="string-length(agent)"/>
				<xsl:variable name="padding" select="29-$ValueLength"/>
				<xsl:value-of select="substring('                                       ',1,$padding)"/>
				<xsl:value-of select="concat('DEPOSIT ',agent)"/>
				<xsl:value-of select="concat('    ',$account)"/>
				<xsl:value-of select="$newline"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="Separate Mappings" userelativepaths="yes" externalpreview="no" url="combinedW100812.xml" htmlbaseurl="" outputurl="" processortype="internal" useresolver="yes" profilemode="7" profiledepth="" profilelength=""
		          urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal"
		          customvalidator=""/>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no">
			<SourceSchema srcSchemaPath="combinedW060809.xml" srcSchemaRoot="csv_data_records" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/>
			<SourceSchema srcSchemaPath="mappings.xml" srcSchemaRoot="mappings" AssociatedInstance="file:///c:/mappings.xml" loaderFunction="document" loaderFunctionUsesURI="no"/>
		</MapperInfo>
		<MapperBlockPosition>
			<template match="csv_data_records"></template>
			<template name="RemoveAlphas"></template>
		</MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->