--空想的沉吟
function c10122005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,10122005)
	e1:SetTarget(c10122005.target)
	e1:SetOperation(c10122005.activate)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122005,4))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10122105)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10122005.setcost)
	e2:SetTarget(c10122005.settg)
	e2:SetOperation(c10122005.setop)
	c:RegisterEffect(e2)  
end
function c10122005.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,10122011) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,10122011)
	Duel.Release(g,REASON_COST)
end
function c10122005.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c10122005.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c10122005.desfilter(c)
	return c:IsFaceup() and c:IsCode(10122011) and c:IsDestructable()
end
function c10122005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10122005.desfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c10122005.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c10122005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local sc=e:GetLabelObject()
	local tg1=Duel.GetMatchingGroup(c10122005.tgfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local tg2=Duel.GetMatchingGroup(c10122005.tgfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,tp)
	if sg:GetCount()==2 and Duel.Destroy(sg,REASON_EFFECT)==2 then
	  local op=0
	  if (tg1:GetCount()>0 or tg2:GetCount()>0) and Duel.SelectYesNo(tp,aux.Stringid(10122005,2)) then
		Duel.BreakEffect()
		if tg1:GetCount()>0 and tg2:GetCount()>0 then
		 op=Duel.SelectOption(tp,aux.Stringid(10122005,0),aux.Stringid(10122005,1))
		elseif tg1:GetCount()>0 then
		 op=Duel.SelectOption(tp,aux.Stringid(10122005,0))
		else
		 op=Duel.SelectOption(tp,aux.Stringid(10122005,1))+1
		end
		   if op==0 then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  local tg=tg1:Select(tp,1,1,nil)
				 Duel.SendtoHand(tg,nil,REASON_EFFECT)
				 Duel.ConfirmCards(1-tp,tg)
		   else
			  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122005,3))
			  local ac=tg2:Select(tp,1,1,nil):GetFirst()
			  local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(ac,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=ac:GetActivateEffect()
				local tep=ac:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(ac,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		   end
	   end
	end
end
function c10122005.tgfilter1(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand() and c:IsSetCard(0xc333) and not c:IsLocation(LOCATION_HAND)
end
function c10122005.tgfilter2(c,tp)
	return bit.band(c:GetType(),0x80002)==0x80002 and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xc333)
end
