--Nanahira Revolution
local m=37564543
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(function(e,c)
		return c.Senya_desc_with_nanahira
	end)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,sp)
	return c:GetSummonPlayer()==sp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil,1-tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and c.Senya_desc_with_nanahira
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,m*16) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
			Duel.BreakEffect()
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif Duel.GetMZoneCount(tp)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end