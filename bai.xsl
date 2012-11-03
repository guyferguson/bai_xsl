
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text"/>
	<!-- This stylesheet converts CommBiz CBA bank data into a cemtex formatted file for upload to PHX -->
	<xsl:variable name="newline">
		<xsl:text>
</xsl:text>
	</xsl:variable>
	<!-- A variable to define the width of an account name field -->
	<xsl:variable name="AcNameWidth">32</xsl:variable>
	<xsl:variable name="AcWidth">9</xsl:variable>
	<!-- a variable to store the name of the Financial Institution-->
	<xsl:variable name="OurName">WARATAH COOPERATIVE HOUSIN</xsl:variable>
	<!-- a variable to store the name of the Trace Record BSB, based on the CBA Gateway ID  -->
	<xsl:variable name="TraceBSB">064-000011340003</xsl:variable>
	<!-- A variable for the BSB (without the hyphen)-->
	<xsl:variable name="BSBdig">803999</xsl:variable>
	<!-- A variable for the BSB (with the hyphen), also based on the CBA Gateway ID  -->
	<xsl:variable name="BSBhyph">803-999</xsl:variable>
	<!-- A variable for the supplier ID, also based on the CBA Gateway ID  -->
	<xsl:variable name="SuppID">999999</xsl:variable>
	<!-- A variable for the Remitter, also based on the CBA Gateway ID  -->
	<xsl:variable name="Remitter">OTC CBA DEP BOOK</xsl:variable>
	<!-- a variable to store the file date for regular use-->
	<xsl:variable name="filedate">
		<xsl:for-each select="csv_data_records/record [Header=2] [Narration='AUD']">
			<xsl:value-of select="substring(BankCode,5,2)"/>
			<xsl:value-of select="substring(BankCode,3,2)"/>
			<xsl:value-of select="substring(BankCode,1,2)"/>
		</xsl:for-each>
	</xsl:variable>
	<!-- Create a string showing each bank account header (=03) separated by | -->
	<!-- Thanks to Dimitre Novatchev at http://aspn.activestate.com/ASPN/Mail/Message/xsl-list/1913969 for this -->
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
	<!-- Variables to count various transactions we need broken up and values etc -->
	<xsl:variable name="MISWMallCNT">
		<xsl:for-each select="csv_data_records/record">
			<xsl:choose>
				<xsl:when test="Header=03 and DrCr =400010434278 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='MIS']"/>
					<xsl:value-of select="count($QCC)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
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
				<xsl:when test="Header=03 and DrCr=400010434278 and date=015">
					<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'       )"/>
					<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
					<xsl:variable name="QCC" select="following-sibling::record [position() &lt;=       $vNumNested and DrCr=399 and BankCode='MIS']"/>
					<xsl:value-of select="sum($QCC/./Amount)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
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

	<!-- 271106 Added coding to handle removal of 804-603 transfers fromWaratah to CBA to avoid them being double posted -->
	<xsl:variable name="WARbsbCNT" select="count(csv_data_records/record [BankCode='MIS'] [contains(Narration,'Daily 804603') or contains(Narration,'DAILY 804603')])"/>
	<!-- <xsl:variable name="WARfundCNT" select="count(csv_data_records/record [BankCode='MIS'] [contains(Narration,'FINDING') or contains(Narration,'Finding')])"/> -->
	<xsl:variable name="WARfxupCNT" select="count(csv_data_records/record [BankCode='MIS'] [contains(Narration,'WCHS INT TFR') or contains(Narration,'FXUP') or contains(Narration,'fxup')])"/>
	<xsl:variable name="AGNallCNT" select="count(csv_data_records/record [BankCode='AGN'])"/>
	<xsl:variable name="MISallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS'])"/>
	<xsl:variable name="MISbpyCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'BPAY PAYMENTS CODE')])"/>
	<xsl:variable name="MISfhgCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'FIRST HOME OWNER')])"/>
	<xsl:variable name="MISatoCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'ATO98023685296')])"/>
	<xsl:variable name="FFNallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='FFN'])"/>
	<xsl:variable name="OURallCNT" select="count(csv_data_records/record [DrCr=399] [agent=299 or agent =999])"/>
	<xsl:variable name="INTallCNT" select="count(csv_data_records/record [DrCr=399] [agent=276])"/>
	<xsl:variable name="DEallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='D E'])"/>
	<xsl:variable name="INSallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='INS'])"/>
	<xsl:variable name="REVallCNT" select="count(csv_data_records/record [DrCr=399] [BankCode='REV'])"/>
	<xsl:variable name="WARbsbVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'Daily 804603') or contains(Narration,'DAILY 804603')]/./Amount)"/>
	<!-- <xsl:variable name="WARfundVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'FINDING') or contains(Narration,'Finding')]/./Amount)"/> -->
	<xsl:variable name="WARfxupVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'FXUP') or contains(Narration,'WCHS INT TFR') or contains(Narration,'fxup')]/./Amount)"/>
	<xsl:variable name="BPYallCNT" select="count(csv_data_records/record [DrCr=399] [Header=30])"/>
	<xsl:variable name="AGNallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='AGN']/./Amount)"/>
	<xsl:variable name="MISallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS']/./Amount)"/>
	<xsl:variable name="MISbpyVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'BPAY PAYMENTS CODE')]/./Amount)"/>
	<xsl:variable name="MISfhgVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'FIRST HOME OWNER')]/./Amount)"/>
	<xsl:variable name="MISatoVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='MIS'] [contains(Narration,'ATO98023685296')]/./Amount)"/>
	<xsl:variable name="FFNallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='FFN']/./Amount)"/>
	<xsl:variable name="OURallVAL" select="sum(csv_data_records/record [DrCr=399]   [agent=299 or agent=999]/./Amount)"/>
	<xsl:variable name="INTallVAL" select="sum(csv_data_records/record [DrCr=399] [agent=276]/./Amount)"/>
	<xsl:variable name="DEallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='D E']/./Amount)"/>
	<xsl:variable name="INSallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCode='INS']/./Amount)"/>
	<xsl:variable name="BPYallVAL" select="sum(csv_data_records/record [DrCr=399]   [Header=30]/./Amount)"/>
	<xsl:variable name="REVallVAL" select="sum(csv_data_records/record [DrCr=399] [BankCoder='REV']/./Amount)"/>
	<!-- Now start constructing the text file in CEMTEX (also know as aba) format -->
	<!--Add row One to the CEMTEX file -->
	<xsl:template match="csv_data_records">
		<xsl:text>0                 01CRU       </xsl:text>
		<xsl:value-of select="concat($OurName,$SuppID,'COMMBIZ--TRN',$filedate)"/>
		<xsl:text>                                        </xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="record"/>
		<!--Add final row to the CEMTEX file, with dollar-value totals and count of files for verification -->
		<xsl:text>7999-999            </xsl:text>
		<xsl:value-of select="format-number(($AGNallVAL + $DEallVAL + $FFNallVAL  + $INSallVAL  + $MISallVAL  - $MISWMallVAL + $BPYallVAL  -    $MISbpyVAL  - $OURallVAL  - $MISfhgVAL  - $INTallVAL  - $MISatoVAL  - $WARbsbVAL   - $WARfxupVAL - $MISGSSmbfVAL - $DEGSSmcareVAL),'0000000000')"/>
		<xsl:value-of select="format-number(($AGNallVAL  + $DEallVAL + $FFNallVAL  + $INSallVAL  + $MISallVAL  - $MISWMallVAL  + $BPYallVAL  -    $MISbpyVAL   - $OURallVAL  - $MISfhgVAL  - $INTallVAL  - $MISatoVAL  - $WARbsbVAL   - $WARfxupVAL - $MISGSSmbfVAL - $DEGSSmcareVAL  ),'0000000000')"/>
		<xsl:text>0000000000                        </xsl:text>
		<xsl:value-of select="format-number(($AGNallCNT  + $DEallCNT  + $FFNallCNT  + $INSallCNT  + $MISallCNT -$MISWMallCNT  + $BPYallCNT  -    $MISbpyCNT   - $OURallCNT  - $MISfhgCNT - $INTallCNT  - $MISatoCNT  - $WARbsbCNT  -$WARfxupCNT - $MISGSSmbfCNT - $DEGSSmcareCNT),'000000')"/>
		<xsl:text>                                        </xsl:text>
		<!-- -->
	</xsl:template>
	<xsl:template match="record">
		<xsl:choose>
			<!-- Choose the Waratah statement transactions - always a 'date' of 15 -->
			<xsl:when test="Header=03 and not(DrCr=400010434278)  and date=15">
				<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|')"/>
				<xsl:variable name="vNumNested" select="$vposNext - position() - 2"/>
				<xsl:variable name="QCHSitems" select="following-sibling::record [position()      &lt;= $vNumNested and DrCr=399 and Header=16]"/>
				<xsl:call-template name="processStatDataItems">
					<xsl:with-param name="items" select="$QCHSitems"/>
					<xsl:with-param name="account" select="DrCr"/>
				</xsl:call-template>
			</xsl:when>
			<!-- Choose the Waratah BPAY transactions - always a 'date' of 231 -->
			<xsl:when test="Header=03 and date=231">
				<xsl:variable name="vposNext" select="substring-before(substring-after($vposArray,concat('|',position(),'|')),'|'      )"/>
				<xsl:variable name="vNumNested" select="$vposNext - position() - 1"/>
				<xsl:variable name="QCHSitems" select="following-sibling::record [position()      &lt;= $vNumNested and DrCr=399 and Header=30]"/>
				<xsl:call-template name="processBPAYItems">
					<xsl:with-param name="items" select="$QCHSitems"/>
					<xsl:with-param name="account" select="DrCr"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- The next section creates the individual transaction lines of the cemtex file -->
	<!--Now I want to select the records that have a transaction Header 16, which indicates Transaction Detail Record, and DrCr=399 which means a debit. -->
	<xsl:template name="processStatDataItems">
		<xsl:param name="items"/>
		<xsl:param name="account"/>
		<xsl:for-each select="$items">
			<xsl:sort select="BankCode"/>
			<xsl:sort select="agent" data-type="number"/>
			<xsl:sort select="Narration"/>
			
			
			<!-- 180809 Now do a lookup at this stage to see if there is a mapping from the Narration to an account number.
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
		<!-- Report BPay records -->
		<xsl:for-each select="$items [DrCr=399] [Header=30]">
			<xsl:value-of select="concat('1',$BSBhyph)"/>
			<xsl:call-template name="BPAYTrim"/>
			<xsl:text> 50</xsl:text>
			<xsl:apply-templates select="Amount"/>
			<xsl:call-template name="RemoveDigits"/>
			<xsl:text>CBA DEPOSIT TFRD  </xsl:text>
			<xsl:value-of select="$TraceBSB"/>
			<xsl:text>BPAY PAYMENT    00000000</xsl:text>
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
	</xsl:template>
	<!--Now I want to select the records that have a transaction Header 30, which indicates a BPay Record. -->
	<!-- FUNCTIONS -->
	<!--Add leading blanks to the Agent number -->
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
					<xsl:text>999999999</xsl:text>
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
		<xsl:value-of select="substring('                  ',1,$padding)"/>
		<xsl:value-of select="normalize-space($AgentLookedUp)"/>
	</xsl:template>
	<!-- For accountname, left justified, 32 characters -->
	<xsl:template name="RemoveDigits">
		<xsl:variable name="AccountName">
			<xsl:choose>
				<xsl:when test="translate(Narration, '*#1234567890&amp;.-','')">
					<xsl:variable name="NoDigits" select="normalize-space(translate(Narration, '*#1234567890&amp;.-',''))"/>
					<xsl:value-of select="substring(concat($NoDigits,'                                '),1,$AcNameWidth)"/>
				</xsl:when>
				<xsl:otherwise>NO NAME PROVIDED                </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$AccountName"/>
	</xsl:template>
	<!-- For Narration on members statement, left justified, 16 characters, blank filled. Use normalize-space as when u delete numbers u get 2 spaces in a row -->
	<xsl:template name="DepNarr">
		<xsl:variable name="valueUnstripped" select="string-length(normalize-space(Narration))"/>
		<xsl:variable name="valueStripped" select="string-length(normalize-space(translate(Narration, '*#1234567890&amp;.-','')))"/>
		<xsl:choose>
			<xsl:when test="$valueUnstripped &lt; 17">
				<xsl:value-of select="substring(concat(normalize-space(Narration),'                '),1,16)"/>
			</xsl:when>
			<xsl:when test="$valueStripped &gt; 16">
				<xsl:value-of select="substring(normalize-space(translate(Narration, '*#1234567890&amp;.-','')),1,16)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(concat(normalize-space(translate(Narration, '*#1234567890&amp;.-','')),'                '),1,16)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- For AGN Narration on members statement, left justified, 16 characters, blank filled. Use normalize-space as when u delete numbers u get 2 spaces in a row -->
	<xsl:template name="AGNNarr">
		<xsl:variable name="valueLength" select="string-length(agent)"/>
		<xsl:choose>
			<xsl:when test="$valueLength &gt; 16">
				<xsl:value-of select="substring(agent,1,16)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(concat('DEPOSIT ',agent,'                '),1,16)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Place left space padding to a variable -->
	<xsl:template name="LeftPad">
		<xsl:variable name="LettersOnly" select="translate(Narration, '1234567890&amp;.-','')"/>
		<xsl:variable name="valueLength" select="string-length(normalize-space($LettersOnly))"/>
		<xsl:variable name="padding" select="$AcNameWidth - $valueLength"/>
		<xsl:value-of select="substring('                          ',1,$padding)"/>
		<xsl:value-of select="Narration"/>
	</xsl:template>
	<!-- A template to remove the alphas out of the narration, then add leading blanks, to try to end up with something like an account number -->
	<xsl:template name="RemoveAlphas">
		<xsl:param name="mappedAccountNumber"/>
		<xsl:variable name="AccountNo">
			<xsl:choose>
				<!-- See if the earlier look up of mappings resulted in an account number - if so, use this value -->
				<xsl:when test="(string-length($mappedAccountNumber) &gt; 9)">
					<xsl:text>999999999</xsl:text>
				</xsl:when>
				<xsl:when test="(string-length($mappedAccountNumber) &gt; 0 and string-length($mappedAccountNumber) &lt; 10)">
					<xsl:value-of select="$mappedAccountNumber"/>
				</xsl:when>
				<!-- just return the number in the narration, stripped of alpha characters -->
				<xsl:when test="translate(Narration,'#*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ&amp;:. -','')">
					<!-- If no valid mapped reference then just strip out the non-numeric characters from the reference-->
					<xsl:variable name="NoLetters" select="translate(Narration, '#*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ&amp;:. -','')"/>
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
				<xsl:otherwise>123456789</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ValueLength" select="string-length(normalize-space($AccountNo))"/>
		<xsl:variable name="padding" select="$AcWidth - $ValueLength"/>
		<xsl:value-of select="substring('                  ',1,$padding)"/>
		<xsl:value-of select="normalize-space($AccountNo)"/>
	</xsl:template>
	<!-- A template to format the amount to give leading zeroes -->
	<xsl:template match="Amount">
		<xsl:number value="." format="0000000001"/>
	</xsl:template>
	<!-- A template to trim the final digit off the BPAY CRN to make it a valid member number number-->
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
				<xsl:when test="BankCode='MIS' and DrCr=399 and not (contains(Narration,'Daily 804603')) and not (contains(Narration,'DAILY 804603')) and not (contains(Narration,'ATO98023685296')) and not(contains(Narration,'FIRST HOME OWNER')) and not (contains(Narration,'WCHS INT TFR')) and not (contains(Narration,'FXUP')) and not (contains(Narration,'fxup')) and not(contains(Narration,'BPAY PAYMENTS CODE'))  and not($account='400010453604' and contains(Narration,'MBF'))">
					<xsl:value-of select="concat('1',$BSBhyph)"/>
					<xsl:call-template name="RemoveAlphas">
					<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
					<xsl:text> 50</xsl:text>
					<xsl:apply-templates select="Amount"/>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:text>CBA DEPOSIT TFRD  </xsl:text>
					<xsl:value-of select="$TraceBSB"/>
					<xsl:call-template name="DepNarr"/>
					<xsl:text>00000000</xsl:text>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<!-- Report INS types -->
				<xsl:when test="BankCode='INS' and DrCr=399">
					<xsl:value-of select="concat('1',$BSBhyph)"/>
					<xsl:call-template name="RemoveAlphas">
				<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
					<xsl:text> 50</xsl:text>
					<xsl:apply-templates select="Amount"/>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:text>CBA DEPOSIT TFRD  </xsl:text>
					<xsl:value-of select="$TraceBSB"/>
					<xsl:call-template name="DepNarr"/>
					<xsl:text>00000000</xsl:text>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<!-- Report D E (Direct Entry) types, excluding Agent 276s which are CBA Term Deposit interest -->
				<xsl:when test="BankCode='D E' and DrCr=399 and not(agent=276) and not(contains(Narration,'MCARE BENEFITS'))">
					<xsl:value-of select="concat('1',$BSBhyph)"/>
					<xsl:call-template name="RemoveAlphas">
				<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
					<xsl:text> 50</xsl:text>
					<xsl:apply-templates select="Amount"/>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:text>CBA DEPOSIT TFRD  </xsl:text>
					<xsl:value-of select="$TraceBSB"/>
					<xsl:call-template name="DepNarr"/>
					<xsl:text>00000000</xsl:text>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<!-- Report FFN types, excluding Debit FFNs -->
				<xsl:when test="BankCode='FFN' and DrCr=399">
					<xsl:value-of select="concat('1',$BSBhyph)"/>
				<xsl:call-template name="RemoveAlphas">
				<xsl:with-param name="mappedAccountNumber" select="$mappedAccountNumber"/>
				</xsl:call-template>
					<xsl:text> 50</xsl:text>
					<xsl:apply-templates select="Amount"/>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:text>CBA DEPOSIT TFRD  </xsl:text>
					<xsl:value-of select="$TraceBSB"/>
					<xsl:call-template name="DepNarr"/>
					<xsl:text>00000000</xsl:text>
					<xsl:value-of select="$newline"/>
				</xsl:when>
				<!-- Report AGN (Agent deposit books) types -->
				<xsl:when test="BankCode='AGN' and DrCr=399 and not(agent=299) and not(agent=999)">
					<xsl:value-of select="concat('1',$BSBhyph)"/>
					<xsl:call-template name="LeftPadAGN"/>
					<xsl:text> 50</xsl:text>
					<xsl:apply-templates select="Amount"/>
					<xsl:call-template name="RemoveDigits"/>
					<xsl:text>CBA DEPOSIT TFRD  </xsl:text>
					<xsl:value-of select="$TraceBSB"/>
					<xsl:call-template name="AGNNarr"/>
					<xsl:text>00000000</xsl:text>
					<xsl:value-of select="$newline"/>
				</xsl:when>
			</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2009. Progress Software Corporation. All rights reserved.

<metaInformation>
	<scenarios>
		<scenario default="yes" name="BAI Creation" userelativepaths="yes" externalpreview="no" url="combinedW100812.xml" htmlbaseurl="" outputurl="" processortype="msxml6" useresolver="no" profilemode="0" profiledepth="" profilelength="" urlprofilexml=""
		          commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/>
	</scenarios>
	<MapperMetaTag>
		<MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
		<MapperBlockPosition></MapperBlockPosition>
		<TemplateContext></TemplateContext>
		<MapperFilter side="source"></MapperFilter>
	</MapperMetaTag>
</metaInformation>
-->