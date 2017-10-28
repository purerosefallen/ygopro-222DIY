--LA SY 六耀的虹光丘兒
function c1200051.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfba),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200051,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1200051.pctg)
	e1:SetOperation(c1200051.pcop)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200051,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1200051.target2)
	e1:SetOperation(c1200051.operation2)
	c:RegisterEffect(e1)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200051,2))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c1200051.con)
	e1:SetTarget(c1200051.tg)
	e1:SetOperation(c1200051.op)
	c:RegisterEffect(e1)
end
function c1200051.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsSetCard(0xfba)
end
function c1200051.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c1200051.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c1200051.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c1200051.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c1200051.filter2(c)
	return c:IsSetCard(0xfbc) and c:IsType(TYPE_CONTINUOUS)
end
function c1200051.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1200051.filter2,tp,LOCATION_DECK,0,1,nil) end
end
function c1200051.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local g=Duel.SelectMatchingCard(tp,c1200051.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function c1200051.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
end
function c1200051.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba) and c:IsReleasable()
end
function c1200051.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200051.rfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_ONFIELD,1,nil) end
end

function c1200051.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(c1200051.rfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_ONFIELD,1,nil)) then return false end
	local rg=Duel.SelectMatchingCard(tp,c1200051.rfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local m=Duel.Release(rg,REASON_EFFECT)
	if m>0 then
		Duel.BreakEffect()
		local rgg=Duel.SelectMatchingCard(tp,Card.IsReleasable,0,LOCATION_ONFIELD,1,m,nil)
		Duel.Release(rgg,REASON_EFFECT)
	end
end