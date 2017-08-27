--★修羅の犲狼（さいろう）　爾子(にこ)・丁禮(ていれい)
function c114100578.initial_effect(c)
	--without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114100578,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c114100578.ntcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c114100578.condition)
	e2:SetTarget(c114100578.target)
	e2:SetOperation(c114100578.operation)
	c:RegisterEffect(e2)
end
function c114100578.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c114100578.confilter2(c)
	return ( c:IsFaceup() or c:IsLocation(LOCATION_GRAVE) ) 
	and ( c:IsSetCard(0x221) or c:IsSetCard(0x988) )
	and c:IsType(TYPE_MONSTER)
end
function c114100578.confilter3(c)
	return c:IsType(TYPE_MONSTER) 
	and ( c:IsFacedown() or not ( c:IsSetCard(0x221) or c:IsSetCard(0x988) ) )
end
function c114100578.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
	and Duel.IsExistingMatchingCard(c114100578.confilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	and not Duel.IsExistingMatchingCard(c114100578.confilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c114100578.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c114100578.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local a=Duel.GetAttacker()
		if a:IsAttackable() and not a:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_DAMAGE_CALCULATING)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
			e1:SetOperation(c114100578.atkop)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BATTLED)
			e2:SetOperation(c114100578.rmop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
			--
			Duel.CalculateDamage(a,c)
		end
	end
end
function c114100578.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(800)
	c:RegisterEffect(e1)
end
function c114100578.rmop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d==e:GetHandler() then Duel.Remove(d,POS_FACEUP,REASON_EFFECT) end
end