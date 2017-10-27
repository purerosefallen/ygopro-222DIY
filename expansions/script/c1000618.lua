--圆环真理
function c1000618.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000618,3))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(4)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c1000618.effcon)
	e2:SetTarget(c1000618.tg)
	e2:SetOperation(c1000618.op)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c1000618.effcon)
	e3:SetValue(c1000618.atkval)
	e3:SetTarget(c1000618.tg2)
	e3:SetLabel(5)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1000618,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetLabel(6)
	e4:SetCondition(c1000618.effcon)
	e4:SetCost(c1000618.cost)
	e4:SetTarget(c1000618.target2)
	e4:SetOperation(c1000618.operation)
	c:RegisterEffect(e4)
	--reflect damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_REFLECT_DAMAGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetLabel(7)
	e5:SetCondition(c1000618.effcon)
	e5:SetValue(c1000618.ref)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1000618,2))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetLabel(8)
	e6:SetCondition(c1000618.drcon)
	e6:SetCost(c1000618.cost2)
	e6:SetTarget(c1000618.drtg)
	e6:SetOperation(c1000618.drop)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetLabel(9)
	e7:SetCondition(c1000618.effcon)
	e7:SetTarget(c1000618.sptg)
	e7:SetOperation(c1000618.spop)
	c:RegisterEffect(e7)
end
function c1000618.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc204) and not c:IsType(TYPE_PENDULUM)
end
function c1000618.effcon(e)
	return Duel.GetMatchingGroup(c1000618.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c1000618.tdfilter(c,tp)
	return  c:IsSetCard(0xc204) and cIsType(TYPE_MONSTER) and c:IsFaceup() 
	and c:GetReasonPlayer()==1-tp and c:IsAbleToDeck() and not c:IsType(TYPE_PENDULUM)
end
function c1000618.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c1000618.tdfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c1000618.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if eg:GetCount()>0 then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end
function c1000618.tg2(e,c)
	return c:IsSetCard(0xc204) and c:IsFaceup() and not c:IsType(TYPE_PENDULUM)
end
function c1000618.atkval(e,c)
	return Duel.GetMatchingGroup(c1000618.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*100
end
function c1000618.reval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c1000618.ref(e,re,val,r,rp,rc)
	return  (bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0) and val<=1200
end
function c1000618.refilter(c)
	return c:IsSetCard(0xc204) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(Card.IsAbleToRemove,0,0,LOCATION_ONFIELD,1,nil)
end
function c1000618.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c1000618.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	if c1000618.cost(e,tp,eg,ep,ev,re,r,rp,0) and c1000618.target2(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		and Duel.GetMatchingGroup(c1000618.cfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
		and Duel.SelectYesNo(tp,aux.Stringid(1000618,1)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c1000618.operation)
		c1000618.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c1000618.target2(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c1000618.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000618.refilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(1000618)==0 end
	local cg=Duel.SelectMatchingCard(tp,c1000618.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RegisterFlagEffect(1000618,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c1000618.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c1000618.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c1000618.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and  ev>=1300 and Duel.GetMatchingGroup(c1000618.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c1000618.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1000618.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1000618.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1000618.spfilter(c,e,tp)
	return  c:IsSetCard(0xc204) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsType(TYPE_PENDULUM)
end
function c1000618.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c1000618.spop(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000618.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end