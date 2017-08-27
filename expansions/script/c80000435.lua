--ＰＭ 毒拉蜜妮
function c80000435.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SEASERPENT),aux.NonTuner(Card.IsSetCard,0x2d0),1)
	c:EnableReviveLimit() 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c80000435.destg)
	e1:SetOperation(c80000435.desop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000435,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000435.damtg)
	e2:SetOperation(c80000435.damop)
	c:RegisterEffect(e2) 
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)   
end
function c80000435.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c80000435.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dam=c:GetFlagEffectLabel(80000435)
	if dam==nil then
		c:RegisterFlagEffect(80000435,RESET_EVENT+0x1fe0000,0,0,400)
		dam=400
	else
		dam=dam*2
		c:SetFlagEffectLabel(80000435,dam)
	end
	Duel.Damage(1-tp,dam,REASON_EFFECT,true)
end
function c80000435.filter(c,atk)
	return c:IsType(TYPE_FIELD)
end
function c80000435.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c80000435.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
	local g=Duel.GetMatchingGroup(c80000435.filter,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c80000435.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c80000435.filter,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	end
end