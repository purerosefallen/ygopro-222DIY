--冰灵之链
function c80001024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	e1:SetCountLimit(1,80001024)
	e1:SetTarget(c80001024.sptg1)
	e1:SetOperation(c80001024.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,80001024)
	e2:SetCondition(c80001024.spcon)
	e2:SetCost(c80001024.spcost)
	e2:SetTarget(c80001024.sptg2)
	e2:SetOperation(c80001024.spop)
	c:RegisterEffect(e2)  
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80001024,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,80001025)
	e4:SetCondition(c80001024.drcon)
	e4:SetTarget(c80001024.drtg)
	e4:SetOperation(c80001024.drop)
	c:RegisterEffect(e4)  
	--act in hand
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e9:SetCondition(c80001024.handcon)
	c:RegisterEffect(e9)
end
function c80001024.filter1(c)
	return c:IsFaceup() and c:IsCode(80001014)
end
function c80001024.handcon(e)
	return Duel.IsExistingMatchingCard(c80001024.filter1,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c80001024.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and c:IsRace(RACE_WINDBEAST)
end
function c80001024.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80001024.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(80001024,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		e:GetHandler():RegisterFlagEffect(80001024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
	end
end
function c80001024.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c80001024.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(80001024)==0 end
	e:GetHandler():RegisterFlagEffect(80001024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80001024.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80001024.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80001024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(80001024)==0 then return end
	if not Duel.NegateAttack() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001024.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c80001024.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsAttackable(ATTRIBUTE_WATER)
end
function c80001024.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80001024.cfilter,1,nil,tp)
end
function c80001024.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80001024.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c80001024.drcon1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	return res and teg:IsExists(c80001024.cfilter,1,nil,tp)
end
function c80001024.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE
		or (res and teg:IsExists(c80001024.cfilter,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(80001024,1))) then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:GetHandler():RegisterFlagEffect(80001024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(80001024,2))
	else
		e:SetCategory(0)
	end
end