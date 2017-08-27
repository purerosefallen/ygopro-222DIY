--白泽球式三段冲
function c22221003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(c22221003.descon)
	e1:SetTarget(c22221003.destg)
	e1:SetOperation(c22221003.desop)
	c:RegisterEffect(e1)
end
c22221003.named_with_Shirasawa_Tama=1
function c22221003.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221003.confilter(c)
	return c:IsFaceup() and c22221003.IsShirasawaTama(c)
end
function c22221003.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22221003.confilter,tp,LOCATION_MZONE,0,3,nil)
end
function c22221003.filter1(c)
	return c:IsFaceup()
end
function c22221003.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22221003.filter3(c)
	return c:IsFacedown()
end
function c22221003.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c22221003.filter1,tp,0,LOCATION_MZONE,1,nil) or
		Duel.IsExistingMatchingCard(c22221003.filter2,tp,0,LOCATION_ONFIELD,1,nil) or
		Duel.IsExistingMatchingCard(c22221003.filter3,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c22221003.filter1,tp,0,LOCATION_MZONE,1,nil) then t[p]=aux.Stringid(22221003,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c22221003.filter2,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(22221003,1) p=p+1 end
	if Duel.IsExistingMatchingCard(c22221003.filter3,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(22221003,2) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22221003,3))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(22221003,0)
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(c22221003.filter1,tp,0,LOCATION_MZONE,nil)
	elseif opt==1 then sg=Duel.GetMatchingGroup(c22221003.filter2,tp,0,LOCATION_ONFIELD,nil)
	else sg=Duel.GetMatchingGroup(c22221003.filter3,tp,0,LOCATION_ONFIELD,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	e:SetLabel(opt)
end
function c22221003.desop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(c22221003.filter1,tp,0,LOCATION_MZONE,nil)
	elseif opt==1 then sg=Duel.GetMatchingGroup(c22221003.filter2,tp,0,LOCATION_ONFIELD,nil)
	else sg=Duel.GetMatchingGroup(c22221003.filter3,tp,0,LOCATION_ONFIELD,nil) end
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end