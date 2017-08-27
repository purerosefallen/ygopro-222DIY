--太初龙魔人
function c10160012.initial_effect(c)
	--choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10160012,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10160012)
	e1:SetCost(c10160012.cost)
	e1:SetTarget(c10160012.tg)
	e1:SetOperation(c10160012.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
end

function c10160012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c10160012.ahfilter(c)
	return c:IsCode(10160009) and c:IsAbleToHand()
end

function c10160012.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c10160012.ahfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,c) and c:IsAbleToRemove()
	local b3=(Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0)
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(10160012,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10160012,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10160012,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	  e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,math.floor(Duel.GetLP(tp)/2))
	elseif sel==2 then
	  e:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	  Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,LOCATION_MZONE)
	  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_ONFIELD)
	else
	  e:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	  Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	end
end

function c10160012.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c10160012.ahfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,c) and c:IsAbleToRemove()
	local b3=(Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0)
	 if sel==1 and b1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tc=Duel.SelectMatchingCard(tp,c10160012.ahfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	   if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c10160012.sumlimit)
		e1:SetValue(c10160012.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		--Duel.RegisterEffect(e1,tp)
		Duel.Damage(tp,math.floor(Duel.GetLP(tp)/2),REASON_EFFECT)
	   end
	 elseif sel==2 and b2 then
	   Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local tg1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
			 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	   local tg2=Duel.SelectMatchingCard(1-tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
			 tg1:Merge(tg2)
			 Duel.SendtoGrave(tg1,REASON_RULE)
	  elseif sel==3 and b3 then
		local h1=Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		local h2=Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		 if h1>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		 end
		 if h2>0 then 
			Duel.Draw(1-tp,1,REASON_EFFECT)
		 end
	  end
end

function c10160012.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsCode(e:GetLabel())
end

function c10160012.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10160012)
	Duel.NegateAttack()
end

function c10160012.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end

function c10160012.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
