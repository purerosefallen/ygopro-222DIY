--夜鸦强盾
function c10116005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(10116005,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c10116005.condition)
	e1:SetTarget(c10116005.target)
	e1:SetOperation(c10116005.activate)
	c:RegisterEffect(e1)	
	--NegateAttack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10116005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10116005.necon)
	e2:SetCost(c10116005.necost)
	e2:SetTarget(c10116005.netg)
	e2:SetOperation(c10116005.neop)
	c:RegisterEffect(e2)
end

function c10116005.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10116005.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c10116005.necon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c10116005.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c10116005.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10116005.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	  Duel.BreakEffect()
	  if Duel.NegateAttack() then
		 Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	  end
	end
end

function c10116005.spfilter(c,e,tp)
	return c:IsSetCard(0x3331)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10116005.tgfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x3331) and c:IsOnField()
end

function c10116005.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or rp==tp then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c10116005.tgfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end

function c10116005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c10116005.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
