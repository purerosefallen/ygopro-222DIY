--闪耀之樱  罗
function c121029233.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c121029233.splimcon)
    e1:SetTarget(c121029233.splimit)
    c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c121029233.reptg)
	e2:SetValue(c121029233.repval)
	e2:SetOperation(c121029233.repop)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(121029233,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c121029233.poscon)
	e3:SetTarget(c121029233.postg)
	e3:SetOperation(c121029233.posop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c121029233.tg)
	e4:SetOperation(c121029233.op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(88241506,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_BECOME_TARGET)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c121029233.spcon)
	e6:SetTarget(c121029233.sptg)
	e6:SetOperation(c121029233.spop)
	c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(88241506,1))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetTarget(c121029233.sptg)
	e7:SetOperation(c121029233.cbop)
	c:RegisterEffect(e7)
end
function c121029233.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c121029233.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x121) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c121029233.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x121)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp))
end
function c121029233.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c121029233.filter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(23310009,6))
end
function c121029233.repval(e,c)
	return c121029233.filter(c,e:GetHandlerPlayer())
end
function c121029233.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c121029233.posfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsSetCard(0x121)
end
function c121029233.poscon(e,tp)
    return Duel.IsExistingMatchingCard(c121029233.posfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c121029233.posfilter2(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanTurnSet()
end
function c121029233.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c121029233.posfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c121029233.posop(e,tp,eg,ep,ev,re,r,rp)
   	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c121029233.posfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c121029233.sefilter(c)
	return c:IsSetCard(0x121) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c121029233.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c121029233.sefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c121029233.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c121029233.sefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c121029233.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c121029233.spfilter(c,e,tp)
	return  c:IsSetCard(0x121) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c121029233.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c121029233.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c121029233.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if  e:GetHandler():IsRelateToEffect(e) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c121029233.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then 	
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if tf(re,rp,ceg,cep,cev,cre,cr,crp,0,g:GetFirst()) and Duel.SelectYesNo(tp,aux.Stringid(23310009,7)) then
	   Duel.BreakEffect()
	   Duel.ChangeTargetCard(ev,Group.FromCards(g:GetFirst()))
	end
end
end
end
function c121029233.cbop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if  e:GetHandler():IsRelateToEffect(e) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c121029233.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then 	
	if not Duel.GetAttacker():IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(23310009,7)) then
		   Duel.BreakEffect()
		   Duel.ChangeAttackTarget(g:GetFirst())
	end
end
end
end