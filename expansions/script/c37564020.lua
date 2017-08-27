--White Rose Insanity
local m=37564020
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_rose=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,37564020+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

function cm.thfilter(c,e,tp)
	return c:IsFaceup() and Senya.check_set_elem(c) and c:GetOverlayCount()>0
	and c:IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode(),c:GetRank())
end
function cm.spfilter2(c,e,tp,code,rk)
	return Senya.check_set_elem(c) and c:GetRank()==rk and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode(),tc:GetRank())
		local mg=sg:GetFirst()
		  if sg:GetCount()>0 and Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if e:GetHandler():IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				e:GetHandler():CancelToGrave()
				Duel.Overlay(mg,Group.FromCards(e:GetHandler()))
			end
		  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
		  end
	end
end