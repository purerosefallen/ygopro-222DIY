--波导的选择
function c80000358.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000358)
	e1:SetCondition(c80000358.condition)
	e1:SetTarget(c80000358.target)
	e1:SetOperation(c80000358.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(80000358,ACTIVITY_SPSUMMON,c80000358.counterfilter)
end
function c80000358.counterfilter(c)
	return c:IsSetCard(0x2d0)
end
function c80000358.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80000358,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80000358.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000358.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2d0)
end
function c80000358.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80000358.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsSetCard(0x2d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000358.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000358.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80000358.spfilter(c,class,e,tp)
	local code=c:GetCode()
	for i=1,class.lvupcount do
		if code==class.lvup[i] then return c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	end
	return false
end
function c80000358.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000358.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	   e:SetLabel(g:GetFirst():GetCode())
	   local code=e:GetLabel()
	   local class=_G["c"..code]
	   if class==nil or class.lvupcount==nil then return end
		if  Duel.SelectYesNo(tp,aux.Stringid(80000358,1)) then
			Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000358.spfilter,tp,LOCATION_DECK,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)	
	end
end
end
end