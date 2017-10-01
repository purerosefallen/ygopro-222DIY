--狂之从者 赫拉克勒斯
function c21401121.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xf07),1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xf0f)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21401121.atkcon)
	e1:SetValue(c21401121.efilter)
	c:RegisterEffect(e1)
    --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c21401121.atkcon)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--to defense
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c21401121.poscon)
	e4:SetOperation(c21401121.posop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c21401121.spcon)
	e5:SetTarget(c21401121.sptg)
	e5:SetOperation(c21401121.spop)
	c:RegisterEffect(e5)
end
function c21401121.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21401121.imfilter(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c21401121.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return  ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c21401121.poscon(e,tp,eg,ep,ev,re,r,rp)
    local bg=Duel.GetAttackTarget()
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle() and bg~=nil and bit.band(bg:GetBattlePosition(),POS_DEFENSE)~=0
end
function c21401121.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c21401121.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=c:GetCounter(0xf0f)
	e:SetLabel(count)
	return count>=1
end
function c21401121.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c21401121.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21401121.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)~=0 and  e:GetLabel()>1 then
		e:GetHandler():AddCounter(0xf0f,e:GetLabel()-1)
		end
end
function c21401121.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end