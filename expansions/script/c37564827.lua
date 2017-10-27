--3L·mokou
local m=37564827
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	aux.AddXyzProcedure(c,cm.mfilter,7,2,nil,nil,63)
	c:EnableReviveLimit()
	Senya.ContinuousEffectGainModule_3L(c,cm.omit_group_3L)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(Senya.DescriptionCost())
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
cm.omit_group_3L=Card.GetOverlayGroup
function cm.effect_operation_3L(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x770)
	e3:SetReset(0x1fe1000)
	c:RegisterEffect(e3,true)
	if c:GetFlagEffect(m+1000)==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(m*16+1)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(cm.MokouRebornCondition)
		e2:SetTarget(cm.MokouRebornTarget)
		e2:SetOperation(cm.MokouRebornOperation)
		c:RegisterEffect(e2,true)
		c:RegisterFlagEffect(m+1000,0,0,0)
	end
	return e3
end
function cm.mfilter(c)
	return Senya.check_set_3L(c)
end
function cm.filter(c)
	return Senya.check_set_3L(c) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ct=63
	for i=1,62 do
		if not e:GetHandler():CheckRemoveOverlayCard(tp,i,REASON_COST) then
			ct=i-1
			break
		end
	end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler()) and e:GetHandler():IsType(TYPE_XYZ) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,ct,e:GetHandler())
	local rct=g:GetCount()
	e:GetHandler():RemoveOverlayCard(tp,rct,rct,REASON_COST)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()==0 then return end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,gg:GetCount(),0,LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.Overlay(e:GetHandler(),tg)
	end
end
function cm.MokouRebornCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousSetCard(0x770)
end
function cm.cfilter(c,e)
	return not c:IsCode(m) and Senya.EffectSourceFilter_3L(c,e:GetHandler()) and Senya.check_set_3L(c)
end
function cm.MokouRebornTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc~=e:GetHandler() and cm.cfilter(chkc,e) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.MokouRebornOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetMZoneCount(tp)<=0 then return end
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,true,true) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	c:CompleteProcedure()
	if tc then Senya.GainEffect_3L(c,tc) end
end