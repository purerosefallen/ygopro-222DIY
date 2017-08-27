--N.五十嵐 響子
function c80030009.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80030009.efilter)
	c:RegisterEffect(e1)   
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80030009.splimcon)
	e2:SetTarget(c80030009.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80030009,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e5:SetCountLimit(1,80030009+EFFECT_COUNT_CODE_DUEL)
	e5:SetCost(c80030009.spcost)
	e5:SetTarget(c80030009.sptg)
	e5:SetOperation(c80030009.spop)
	c:RegisterEffect(e5)
	--flip
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c80030009.eqcon)
	e6:SetTarget(c80030009.thtg)
	e6:SetOperation(c80030009.thop)
	c:RegisterEffect(e6)
	--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetCountLimit(1,80030010+EFFECT_COUNT_CODE_DUEL)
	e7:SetCost(c80030009.cost)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c80030009.target)
	e7:SetOperation(c80030009.activate)
	c:RegisterEffect(e7)
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c80030009.atktarget)
	c:RegisterEffect(e8)
end
function c80030009.atktarget(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030009.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80030009.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80030009.splimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030009.posfilter(c)
	return c:IsSetCard(0x92d4) and c:IsAbleToRemoveAsCost()
end
function c80030009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c80030009.posfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=5 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<5 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=sg:Select(tp,5-ct,5-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:Select(tp,5,5,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80030009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80030009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c80030009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80030009.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c80030009.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)) or c:IsReason(REASON_BATTLE)
end
function c80030009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsPlayerCanDraw(1-tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,e:GetHandler()) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c80030009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,1-tp,5)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(1-tp,g:GetCount(),REASON_EFFECT)
end
function c80030009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil)==5 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end