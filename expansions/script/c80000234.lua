--口袋妖怪万夜游
function c80000234.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c80000234.spcon1)
	e1:SetTarget(c80000234.sptg1)
	e1:SetOperation(c80000234.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000234,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,80000234)
	e2:SetCondition(c80000234.spcon2)
	e2:SetCost(c80000234.spcost)
	e2:SetTarget(c80000234.sptg2)
	e2:SetOperation(c80000234.spop)
	c:RegisterEffect(e2)   
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000234,5))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,80000233)
	e3:SetCondition(c80000234.condition)
	e3:SetTarget(c80000234.target)
	e3:SetOperation(c80000234.operation)
	c:RegisterEffect(e3)
end
function c80000234.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c80000234.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	return res and teg:IsExists(c80000234.cfilter,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000234.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c80000234.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE
		or (res and teg:IsExists(c80000234.cfilter,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000234.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(80000234,1))) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		e:GetHandler():RegisterFlagEffect(80000234,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(80000234,2))
	else
		e:SetCategory(0)
	end
end
function c80000234.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c80000234.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000234.cfilter,1,nil,tp)
end
function c80000234.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(80000234)==0 end
	e:GetHandler():RegisterFlagEffect(80000234,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c80000234.filter(c,e,tp)
	return c:IsSetCard(0x2d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(3) and c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c80000234.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000234.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80000234.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(80000234)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000234.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80000234.filter1(c)
	return c:IsSetCard(0x2d0) and c:IsAbleToHand() and c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c80000234.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000234.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80000234.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000234.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80000234.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.IsExistingMatchingCard(c80000234.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)then
		e:SetCategory(CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
end