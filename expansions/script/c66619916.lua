--爱丽丝的仙境
function c66619916.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c66619916.op4)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90953320,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c66619916.drcon)
	e2:SetTarget(c66619916.drtg)
	e2:SetOperation(c66619916.drop)
	c:RegisterEffect(e2)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(46159582,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c66619916.necost)
	e4:SetTarget(c66619916.netg)
	e4:SetOperation(c66619916.neop)
	c:RegisterEffect(e4)
end
function c66619916.op4(e,tp,eg,ep,ev,re,r,rp)
   local e1=Effect.CreateEffect(e:GetHandler())
   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
   e1:SetCode(EVENT_CHAINING)
   e1:SetCountLimit(1)
   e1:SetCondition(c66619916.chaincon)
   e1:SetOperation(c66619916.chainop)
   e1:SetReset(RESET_PHASE+PHASE_END)
   Duel.RegisterEffect(e1,tp)
end
function c66619916.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x666) and rp==tp
end
function c66619916.chainop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetChainLimit(c66619916.chainlm)
end
function c66619916.chainlm(e,rp,tp)
	return tp==rp
end 
function c66619916.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) 
end
function c66619916.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66619916.cfilter,1,nil,tp)
end
function c66619916.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66619916.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c66619916.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66619916.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66619916.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66619916.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66619916.neop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66619916.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end