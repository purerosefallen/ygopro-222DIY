--应急核心
function c10130013.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetLabel(1)
	e1:SetCountLimit(1,10130013)
	e1:SetTarget(c10130013.settg)
	e1:SetOperation(c10130013.setop)
	c:RegisterEffect(e1)   
	--set2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10130013,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(2)
	e2:SetCondition(c10130013.setcon)
	e2:SetCost(c10130013.setcost)
	e2:SetTarget(c10130013.settg)
	e2:SetOperation(c10130013.setop)
	c:RegisterEffect(e2)   
end
function c10130013.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10130013.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10130013.setfilter(c,e,tp)
	return ((c:IsCode(10130007) and e:GetLabel()==1) or (c:IsSetCard(0xa336) and e:GetLabel()==2)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c10130013.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10130001.setfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10130013.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10130013.setfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
			  if sg:GetCount()>0 then
				 Duel.BreakEffect()
				 Duel.ShuffleSetCard(sg)
			  end
	end
end