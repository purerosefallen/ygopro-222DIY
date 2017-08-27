--★烈(れつ)の魔女っ娘　Sniper the Violet
function c114000977.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c114000977.spcost)
	e1:SetTarget(c114000977.sptg)
	e1:SetOperation(c114000977.spop)
	c:RegisterEffect(e1)
	--indestructable battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c114000977.condition)
	e3:SetTarget(c114000977.target)
	e3:SetOperation(c114000977.operation)
	c:RegisterEffect(e3)
end
--sp summon function
function c114000977.spcfilter(c)
	return c:IsSetCard(0x221)
end
function c114000977.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c114000977.spcfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c114000977.spcfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c114000977.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000977.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c114000977.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c114000977.atkfilter(c)
	return c:IsSetCard(0xcabb) or c:IsSetCard(0x1223)
end
function c114000977.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000977.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c114000977.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=0
		local g=Duel.GetMatchingGroup(c114000977.atkfilter,tp,LOCATION_MZONE,0,c)
		local bc=g:GetFirst()
		while bc do
			atk=atk+bc:GetAttack()
			bc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c114000977.atktg)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabel(c:GetFieldID())
		Duel.RegisterEffect(e2,tp)
	end
end
function c114000977.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end