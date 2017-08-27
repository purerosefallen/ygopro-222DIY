--ピンクソウルジェム -救いの手-
function c114000797.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c114000797.condition)
	e1:SetTarget(c114000797.target)
	e1:SetOperation(c114000797.activate)
	c:RegisterEffect(e1)
	--condition check
	if not c114000797.global_check then
		c114000797.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		ge1:SetOperation(c114000797.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c114000797.handcon)
	c:RegisterEffect(e2)
	--Sent to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c114000797.desop)
	c:RegisterEffect(e3)
	--Destroy itself
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c114000797.descon2)
	e4:SetOperation(c114000797.desop2)
	c:RegisterEffect(e4)
end
--condition check
function c114000797.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,114000797,RESET_PHASE+PHASE_END,0,1)
end
--act in hand
function c114000797.hdfilter(c)
	return c:IsFaceup() and ( c:IsLevelAbove(5) or c:IsType(TYPE_XYZ) )
end
function c114000797.handcon(e)
	return Duel.IsExistingMatchingCard(c114000797.hdfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
--Activate
function c114000797.spfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114000797.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,114000797)>=1
	and not Duel.IsExistingMatchingCard(c114000797.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114000797.filter(c,e,tp)
	return c:IsSetCard(0xcabb) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114000797.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114000797.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114000797.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114000797.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		if tc then
		Duel.SpecialSummon(tc,501,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
	end
end
--continuous relationship
function c114000797.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c114000797.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c114000797.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end