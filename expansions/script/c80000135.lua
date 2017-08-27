--传说中的那片天空
function c80000135.initial_effect(c)
--spsummon1
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c80000135.descost)
	e5:SetCountLimit(1,80000135)
	e5:SetCondition(c80000135.condition)
	e5:SetTarget(c80000135.target)
	e5:SetOperation(c80000135.operation)
	c:RegisterEffect(e5)	
end
function c80000135.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetLP(tp,Duel.GetLP(tp)/10)
end
function c80000135.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80000135.filter(c,e,tp)
	return c:IsSetCard(0x2d0) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsLevelBelow(8)
end
function c80000135.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000135.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000135.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000135.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		end
	Duel.SpecialSummonComplete()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetOperation(c80000135.lpop)
	e2:SetCondition(c80000135.rmcon)
	Duel.RegisterEffect(e2,tp)
end
function c80000135.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=8000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-8000)
	end
end
function c80000135.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end







