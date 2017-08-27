--8计划
local m=37564109
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37564109+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c37564109.cost)
	e1:SetTarget(c37564109.target)
	e1:SetOperation(c37564109.activate)
	c:RegisterEffect(e1)
end
c37564109.list={[37564101]=37564102,[37564102]=37564103,[37564103]=37564104,
				[37564104]=37564105,[37564105]=37564101,[37564110]=37564110}
function c37564109.filter1(c,e,tp)
	if c:IsFacedown() then return false end
	local code=c:GetCode()
	if code==37564111 then return false end
	local tcode=c37564109.list[code]
	return tcode and Duel.IsExistingMatchingCard(c37564109.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,tcode,e,tp)
end
function c37564109.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c37564109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c37564109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==1
		e:SetLabel(0)
		return res and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c37564109.filter1,tp,LOCATION_MZONE,0,1,nil) end
	e:SetLabel(0)
	local rg=Duel.SelectTarget(tp,c37564109.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local code=rg:GetFirst():GetCode()
	local tcode=c37564109.list[code]
	Duel.SetTargetParam(tcode)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
end
function c37564109.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tcode=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c37564109.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tcode,e,tp)
	if g:GetCount()>0 and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		Duel.SendtoGrave(tc,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
