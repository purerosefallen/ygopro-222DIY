--Sawawa-Prism Crash
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564229
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,1,true,false,false)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(37564229,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,37564229)
	e5:SetCondition(Senya.CheckNoExtra)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
end
function cm.drfilter(c,e,tp)
	return Senya.check_set_sawawa(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand() and c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
