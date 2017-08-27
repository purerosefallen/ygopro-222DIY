--元素创造者·Senya
local m=37564022
local cm=_G["c"..m]

xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4,nil,nil,63)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.rettg)
	e3:SetOperation(cm.retop)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():GetOverlayGroup():IsExists(cm.ovfilter,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local sg=c:GetOverlayGroup():FilterSelect(tp,cm.ovfilter,1,1,nil)
		local tc=sg:GetFirst()
		Senya.CopyStatusAndEffect(e,nil,tc,false)
end
function cm.filter(c,e,tp)
	return c:GetRank()==4 and Senya.check_set_elem(c) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.filter2(c)
	return Senya.check_set_elem(c) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then 
		local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
				local sg2=g2:Select(tp,1,1,nil)
				Duel.Overlay(g:GetFirst(),sg2)
			end
		end
	end
end