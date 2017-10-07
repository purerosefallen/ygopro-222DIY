--WL·粉 刺 妖 精
local m=46564051
local cm=_G["c"..m]
function cm.initial_effect(c)
	--set   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target3)
	e2:SetOperation(cm.activate3)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	if c:IsSetCard(0x65c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then return true end
	return c:IsSetCard(0x65c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,tc)
		end
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.filter3(c)
	return c:IsSetCard(0x65c) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x65c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then  Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL) return end
		Duel.DisableShuffleCheck()
		if g:IsExists(cm.spfilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ct=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
			local sg=g:FilterSelect(tp,cm.spfilter,1,ct,nil,e,tp)
			local tc=sg:GetFirst()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			Group.RemoveCard(g,tc)
			g:Sub(sg)
		end   
	end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
end
