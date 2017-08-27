--双龙咆哮
function c10161002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10161002)
	e1:SetCost(c10161002.cost)
	e1:SetTarget(c10161002.target)
	e1:SetOperation(c10161002.activate)
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10161002,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10161002)
	e2:SetCost(c10161002.descost)
	e2:SetTarget(c10161002.destg)
	e2:SetOperation(c10161002.desop)
	--c:RegisterEffect(e2)
	--reflect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10161002)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCost(c10161002.descost)
	e3:SetCondition(c10161002.rfcon)
	e3:SetOperation(c10161002.rfop)
	--c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10161002,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,10161102+EFFECT_COUNT_CODE_DUEL)
	e4:SetCost(c10161002.descost)
	e4:SetOperation(c10161002.operation)
	c:RegisterEffect(e4)
end
c10161002.card_code_list={10160001}
function c10161002.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
		if Duel.GetTurnPlayer()==tp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetLabel(0)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end

function c10161002.rfcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end

function c10161002.rfop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c10161002.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end

function c10161002.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end

function c10161002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10161002.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10161002.desfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c10161002.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c10161002.desfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,g1:GetFirst())
	local dg=Duel.GetMatchingGroup(c10161002.desfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,g2:GetFirst(),g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,LOCATION_MZONE)
end

function c10161002.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Sub(tg)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c10161002.desfilter(c,tp)
	return c:IsSetCard(0x9333) and c:IsFaceup() and Duel.IsExistingTarget(c10161002.desfilter2,tp,LOCATION_MZONE,0,1,c,tp,c)
end

function c10161002.desfilter2(c,tp,dc1)
	return c:IsSetCard(0x9333) and c:IsFaceup() and Duel.IsExistingTarget(c10161002.desfilter3,tp,LOCATION_MZONE,0,1,c,dc1)
end

function c10161002.desfilter3(c,dc1)
	return c:IsDestructable() and c~=dc1
end

function c10161002.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c10161002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end--Duel.GetFlagEffect(tp,10161002)==0 end
	--Duel.RegisterFlagEffect(tp,10161002,0,0,0)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end


function c10161002.filter1(c)
	return c:IsSetCard(0x9333) and c:GetLevel()==9 and c:IsAbleToHand()
end

function c10161002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10161002.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>=2 and g:GetClassCount(Card.GetAttribute)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c10161002.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c10161002.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g1:GetCount()<=0 or g1:GetClassCount(Card.GetAttribute)<=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g1:Select(tp,1,1,nil)
	g1:Remove(Card.IsAttribute,nil,tg:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g1:Select(tp,1,1,nil):GetFirst()   
	tg:AddCard(tc)
	  Duel.SendtoHand(tg,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,tg)
end
