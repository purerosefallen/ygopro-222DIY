--幻层驱动 超Ω构筑
function c10130009.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsSetCard,0xa336),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--Search or SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130009,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10130009)
	e1:SetCost(c10130009.sscost)
	e1:SetTarget(c10130009.sstg)
	e1:SetOperation(c10130009.ssop)
	c:RegisterEffect(e1) 
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130009,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10130109)
	e2:SetTarget(c10130009.rmtg)
	e2:SetOperation(c10130009.rmop)
	c:RegisterEffect(e2)  
end
function c10130009.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c10130009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10130009.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end
function c10130009.ssfilter(c,e,tp)
	return c:IsSetCard(0xa336) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsAbleToHand())
end
function c10130009.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10130009.ssfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c10130009.sspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SelectMatchingCard(tp,c10130009.ssfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op,ct=0,0
		if th and sp then op=Duel.SelectOption(tp,aux.Stringid(10130009,2),aux.Stringid(10130009,3))
		elseif th then op=0
		elseif sp then op=1
		end
		if op==0 then
			ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
		else
			ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
		if ct~=0 then
			Duel.ConfirmCards(1-tp,g)
			local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
			   if sg:GetCount()>0 then
				  Duel.BreakEffect()
				  Duel.ShuffleSetCard(sg)
			   end
		end
	end
end