--口袋妖怪 水水獭
function c80000231.initial_effect(c)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000231,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c80000231.condition)
	e1:SetTarget(c80000231.target)
	e1:SetOperation(c80000231.operation)
	c:RegisterEffect(e1)	
end
c80000231.lvupcount=1
c80000231.lvup={80000232}
function c80000231.condition(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and Duel.GetAttackTarget()==e:GetHandler() and Duel.GetAttacker():IsControler(1-tp)
		and e:GetHandler():GetBattlePosition()==POS_FACEDOWN_DEFENSE
end
function c80000231.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
end
function c80000231.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
		Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000231.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c80000231.spfilter(c,e,tp)
	return c:IsCode(80000232) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end