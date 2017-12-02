--元素引导者·Scorpiour
local m=37564027
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,4,nil,nil,63)
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.indcon)
	e1:SetValue(cm.immfilter)
	c:RegisterEffect(e1)
--ss
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.sscost)
	e3:SetTarget(cm.sstg)
	e3:SetOperation(cm.ssop)
	c:RegisterEffect(e3)
--xm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.rcon)
	e2:SetOperation(aux.TRUE)
	c:RegisterEffect(e2)
end
function cm.immfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.indfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.indfilter(c)
	return c:IsFaceup() and Senya.check_set_elem(c) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function cm.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ssfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.ssfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(cm.ssfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.ssfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.filter1(c)
	return Senya.check_set_elem(c) 
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function cm.xmfilter(c)
	return Senya.check_set_elem(c) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return (r & REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and Senya.check_set_elem(re:GetHandler()) and e:GetHandler():GetOverlayGroup():IsExists(cm.xmfilter,1,nil)
and re:GetHandler()~=e:GetHandler()
end


