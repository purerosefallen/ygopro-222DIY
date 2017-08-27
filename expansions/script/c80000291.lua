--骗术空间
function c80000291.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(e1)
	--swap ad
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c80000291.atcon)
	e2:SetCode(EFFECT_SWAP_BASE_AD)
	c:RegisterEffect(e2)  
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(c80000291.condition)
	e4:SetOperation(c80000291.operation)
	c:RegisterEffect(e4)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000291,5))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c80000291.condition2)
	e3:SetTarget(c80000291.target1)
	e3:SetOperation(c80000291.operation1)
	c:RegisterEffect(e3)
end
function c80000291.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_PSYCHO)
end
function c80000291.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80000291.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80000291.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c80000291.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80000291.operation(e,tp,eg,ep,ev,re,r,rp)
	local ats=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if ats:GetCount()==0 or (at and ats:GetCount()==1) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(80000291,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80000291,1))
		local g=ats:Select(tp,1,1,at)
		Duel.Hint(HINT_CARD,0,80000291)
		Duel.HintSelection(g)
		Duel.ChangeAttackTarget(g:GetFirst())
	end
end
function c80000291.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,0,1-tp,1)
end
function c80000291.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c80000291.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and bit.band(r,0x41)==0x41 and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end