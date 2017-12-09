--妖精传说-奥劳拉
local m=50008005
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.linkfilter,2,2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(cm.immcon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(cm.immcon)
	e2:SetValue(cm.indval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.aclimit1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	e5:SetCondition(cm.econ1)
	e5:SetValue(cm.elimit)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetOperation(cm.aclimit3)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCondition(cm.econ2)
	e7:SetTargetRange(0,1)
	c:RegisterEffect(e7)
	--copy effect
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,0))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1,m)
	e8:SetCost(cm.cpcost)
	e8:SetTarget(cm.cptg)
	e8:SetOperation(cm.cpop)
	c:RegisterEffect(e8)
end
function cm.linkfilter(c)
	return c:GetAttack()==1850 and c:IsRace(RACE_SPELLCASTER)
end
function cm.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.efilter(e,te)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() and tc:GetBaseAttack()>=1850
end
function cm.indval(e,c)
	return c:GetBaseAttack()>=1850
end
--
function cm.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_EQUIP) then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.econ1(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_EQUIP) then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.econ2(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.elimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) and not re:IsActiveType(TYPE_EQUIP) and not re:GetHandler():IsImmuneToEffect(e)
end
--
function cm.costfilter(c)
	return (c:IsRace(RACE_SPELLCASTER) or c:IsType(TYPE_SPELL)) and c:IsDiscardable()
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function cm.cpfilter(c)
	return (c:IsType(TYPE_QUICKPLAY) or c:GetType()==TYPE_SPELL) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end