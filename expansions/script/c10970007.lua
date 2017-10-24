--终曲 「芙蓉石的永恒轮回」
function c10970007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10970007.atg)
	c:RegisterEffect(e1)
  --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10970007,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10970007.cost)
	e2:SetTarget(c10970007.tg)
	e2:SetOperation(c10970007.op)
	c:RegisterEffect(e2)
   local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85827713,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetTarget(c10970007.damtg)
	e3:SetOperation(c10970007.damop)
	c:RegisterEffect(e3)
end
function c10970007.atg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end 
   if c10970007.cost(e,tp,eg,ep,ev,re,r,rp,0) and c10970007.tg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		c10970007.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c10970007.tg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c10970007.op)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10970007.cfilter(c)
	return c:IsSetCard(0x2233) and c:IsFaceup()
end
function c10970007.ffilter(c)
	return c:IsType(TYPE_FIELD)
end
function c10970007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local a=Duel.IsExistingMatchingCard(c10970007.cfilter,tp,LOCATION_FZONE,0,1,nil)
	local b=Duel.IsExistingMatchingCard(c10970007.ffilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,10970007)==0 and (a or not b) end
	  Duel.RegisterFlagEffect(tp,10970007,RESET_PHASE+PHASE_END,0,1)
	if a then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c10970007.cfilter,tp,LOCATION_FZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	elseif not b then
   return true
	end
end
function c10970007.sfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x2233)
end
function c10970007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10970007.sfilter,tp,LOCATION_HAND,0,1,nil)  end
end
function c10970007.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil) then return false end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c10970007.sfilter,tp,LOCATION_HAND,0,1,1,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c10970007.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,2000)
end
function c10970007.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

