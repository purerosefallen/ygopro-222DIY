--幻层驱动器 真空层
function c10130006.initial_effect(c)
	--posion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e1:SetDescription(aux.Stringid(10130006,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10130006)
	e1:SetTarget(c10130006.postg)
	e1:SetOperation(c10130006.posop)
	c:RegisterEffect(e1)	
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetDescription(aux.Stringid(10130005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10130106)
	e2:SetCondition(c10130006.necon)
	e2:SetCost(c10130006.necost)
	e2:SetTarget(c10130006.netg)
	e2:SetOperation(c10130006.neop)
	c:RegisterEffect(e2) 
end
function c10130006.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() and c:IsControler(tp)
end
function c10130006.necon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then 
	return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsExists(c10130006.cfilter,1,nil,tp) then 
	return true end
	local ex,tg2,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg2 and tc+tg2:FilterCount(c10130006.cfilter,nil,tp)-tg2:GetCount()>0 then
	  if re:IsHasCategory(CATEGORY_NEGATE) and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then 
	  return false
	  else return true end
	end
	return false
end
function c10130006.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10130006.neop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c10130006.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
end
function c10130006.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c10130006.posfilter(c)
	return not c:IsSetCard(0xa336) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c10130006.posop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	  if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0 then
		 local tg=Duel.GetOperatedGroup()
		 local tc=tg:GetFirst()
		 while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		tc=tg:GetNext()
		end
	  end
end