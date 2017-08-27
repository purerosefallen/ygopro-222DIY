--Nanahira & Koishi
local m=37564537
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	aux.AddXyzProcedure(c,Senya.NanahiraFilter,7,2)
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ANNOUNCE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.DiscardHandCost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp)
		return Duel.GetTurnPlayer()==tp
	end)
	e2:SetTarget(cm.gaintg)
	e2:SetOperation(cm.gainop)
	c:RegisterEffect(e2)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or ep==tp then return false end
	return re:IsHasCategory(CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_TOHAND)
end
function cm.DiscardHandCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-tp) then return end
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(0x1fe1000+RESET_CHAIN)
	e3:SetLabel(ac)
	e3:SetDescription(cid)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==e:GetDescription()
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(Card.IsControler,nil,1-tp)
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(m,0x1fe1000+RESET_CHAIN,0,1)
		end
	end)
	c:RegisterEffect(e3,true)
	local e1=e3:Clone()
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==e:GetDescription()
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(cm.cf,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
			Duel.ConfirmCards(tp,g)
			local tg=g:Filter(Card.IsCode,nil,e:GetLabel())
			Senya.OverlayGroup(e:GetHandler(),tg)
			Duel.ShuffleHand(1-tp)
		end
	end)
	c:RegisterEffect(e1,true)
end
function cm.cf(c)
	return c:GetFlagEffect(m)>0
end
function cm.gaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if chk==0 then return mg:IsExists(Card.IsAbleToHand,1,nil) end
end
function cm.gainop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetOverlayGroup()
	if mg:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=mg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end