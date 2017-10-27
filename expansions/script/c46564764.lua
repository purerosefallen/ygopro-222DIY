--恋 心 的 弓 矢 ·Hanekoi
local m=46564764
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--cannot destroy by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(cm.rmcon)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(cm.negcost)
	e5:SetTarget(cm.negtg)
	e5:SetOperation(cm.negop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.sptg1)
	e6:SetOperation(cm.spop1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e7)
end
function cm.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>=0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetHandler()
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,tc)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	if ft>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,tc)
	Duel.Remove(g,POS_FACEUP,REASON_COST)   
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=700 and not e:GetHandler():IsHasEffect(EFFECT_REVERSE_UPDATE)  end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(-700)
		e:GetHandler():RegisterEffect(e1)
	end
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.spfilter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(cm.spfilter1,tp,LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
end
