--库拉丽丝-银莲
function c57300022.initial_effect(c)
	xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
	miyuki.AddXyzProcedureClariS(c,3)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(57300022)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(57300122)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(ex)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c57300022.op)
	c:RegisterEffect(e2)
	c57300022[e2]={}
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14970113,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(function(e,tp) return Duel.GetTurnPlayer()~=tp end)
	e4:SetTarget(c57300022.rmtg)
	e4:SetOperation(c57300022.rmop)
	c:RegisterEffect(e4)
end
function c57300022.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c57300022.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c57300022.copyfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsHasEffect(57300022) and ec:GetOverlayCount()>0
end
function c57300022.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function c57300022.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(c57300022.gfilter2,1,nil,c:GetOriginalCode())
end
function c57300022.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function c57300022.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=c57300022[e]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(c57300022.copyfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler())
	local dg=exg:Filter(c57300022.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(c57300022.gfilter1,nil,exg)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		e:SetCondition(c57300022.rcon(e:GetCondition(),tc,copyt))
		f(tc,e,forced)
	end
	for tc in aux.Next(cg) do
		copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
	Card.RegisterEffect=f
end
function c57300022.rcon(con,tc,copyt)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsHasEffect(57300122) then
			c:ResetEffect(c,copyt[tc],RESET_COPY)
			copyt[tc]=nil
			return false
		end
		if not con or con(e,tp,eg,ep,ev,re,r,rp) then return true end
		return e:IsHasType(0x7e0) and c:GetFlagEffect(m)>0
	end
end